# Brief — Configuration NixOS nixbox

## Contexte général

Setup NixOS desktop haute performance avec dual-GPU, ciblant un système
déclaratif et modulaire supportant Linux natif et une VM Windows 11.

## Hardware

- **CPU** : AMD Ryzen 9 9800X3D (pas d'iGPU)
- **GPU 1** : RTX 5070 (GB205 / 10de:2f04) → groupe IOMMU 12 (isolé ✓)
- **GPU 2** : GTX 1050 Ti (GP107 / 10de:1c82) → groupe IOMMU 15 (partagé avec chipset AMD, inéligible au passthrough sans ACS override)
- **RAM** : 16 Go DDR5 6000MHz
- **Stockage** : Crucial E100 2To NVMe
- **Carte mère** : ASUS TUF B650-PLUS
- **Écrans** : AOC Q27G42XE 27" 1440p 180Hz (DP-2, RTX 5070) + écran secondaire 1080p (HDMI-A-3, GTX 1050 Ti)
- **Réseau** : Modem USB sur `enp10s0u2` (Eduroam bloque le trafic non authentifié)

## Partitions

| Partition | UUID | Usage |
|-----------|------|-------|
| nvme0n1p1 | B196-AF2C | EFI |
| nvme0n1p2 | 653343a6-d72e-4929-988a-9d4001f951bf | Linux root |
| nvme0n1p3 | (aucun, raw) | Windows VM block passthrough |
| nvme0n1p4 | eac06185-9fd8-4e38-a41b-59c9c028e540 | Data Linux + partage VM |

## Structure des fichiers

```
/etc/nixos/
├── configuration.nix       # imports + config système de base
├── hardware-configuration.nix
├── flake.nix               # inputs : nixpkgs 26.05, home-manager, plasma-manager
├── flake.lock
├── network.nix             # NetworkManager, bridge enp10s0u2
├── gpu.nix                 # Nvidia open (RTX 5070) + nouveau (GTX 1050 Ti)
├── desktop.nix             # KDE Plasma 6, SDDM, PipeWire, swap canaux audio
├── packages.nix            # systemPackages, Steam, Docker, Flatpak
├── vm.nix                  # libvirtd, QEMU/KVM, OVMF, swtpm
├── home.nix                # Home Manager base, imports plasma.nix + vscode.nix
├── plasma.nix              # plasma-manager : panel, iconTasks
└── vscode.nix              # extensions, settings, packages home
```

## Commande de rebuild

```bash
sudo nixos-rebuild switch --flake /etc/nixos#nixbox
```

## Configurations de boot

- **Lwin** (défaut) : RTX 5070 + GTX 1050 Ti sur NixOS, VM Windows avec GPU émulé (bureautique)
- **Wlin** (specialisation) : RTX 5070 passthrough VM, GTX 1050 Ti sur NixOS

## Drivers GPU

- **RTX 5070** : driver Nvidia open (`open = true` obligatoire pour GB205+)
- **GTX 1050 Ti** : `nouveau` via service systemd (driver 595.xx ne la supporte plus)
  - NixOS blackliste nouveau automatiquement quand Nvidia est actif → service `load-nouveau` le force après

## Audio

PipeWire avec loopback pour inverser les canaux gauche/droite sur
`alsa_output.pci-0000_0c_00.6.analog-stereo`. Sink virtuel `swap_input`
défini comme sortie par défaut.

## Home Manager & plasma-manager

- Intégré comme module NixOS (Option A)
- `useGlobalPkgs = true`, `useUserPackages = true`
- plasma-manager : les favoris Kickoff ne sont pas supportés → utilisation de `iconTasks`
- VSCode géré via `programs.vscode.profiles.default`

## VM Windows

Deux profils XML libvirt (à créer dans virt-manager) :

### Lwin (GPU émulé)
- RAM : 8192 MiB (balloon, min 4096)
- vCPUs : 8
- GPU : QXL/VirtIO-GPU émulé
- Affichage : SPICE (fenêtre KDE)
- Disque : `/dev/nvme0n1p3` raw block

### Wlin (RTX 5070 passthrough)
- RAM : 12288 MiB (balloon, min 4096)
- vCPUs : 8
- GPU : RTX 5070 passthrough (01:00.0 + 01:00.1, vfio-pci.ids=10de:2f04,10de:2f80)
- Affichage : sortie directe sur DP-2
- Disque : `/dev/nvme0n1p3` raw block

## Points techniques importants

- `hardware.opengl` est déprécié → utiliser `hardware.graphics.enable = true`
- `nixpkgs.config.allowUnfree = true` requis (Nvidia, VSCode, Steam, claude-code)
- `programs.nix-ld.enable = true` requis pour les binaires non-NixOS (extension VSCode Claude Code)
- `configuration.nix` sans header `{ config, pkgs, ... }:` quand il ne fait qu'importer
- Flake inputs : `nixpkgs` 26.05, `home-manager` release-26.05, `plasma-manager`
- Rebuild : `sudo nixos-rebuild switch --flake /etc/nixos#nixbox`

## Applications installées

### NixOS (systemPackages)
Firefox, GIMP, VLC, Audacity, FreeCAD, VSCode, Python3, GCC, Git,
Steam, Docker, Flatpak (Bambu Lab Studio), claude-code, nil, statix,
deadnix, nixpkgs-fmt, nvtop, htop, pciutils, virt-manager

### VM Windows (à installer via winget)
Microsoft Office, DaVinci Resolve, Steam

## À faire

- [ ] Créer les fichiers XML libvirt pour Lwin et Wlin dans virt-manager
- [ ] Installer Windows 11 sur nvme0n1p3
- [ ] Configurer VirtIO-FS pour le partage `/data/shared`
- [ ] Tester le passthrough RTX 5070 en mode Wlin
- [ ] Configurer Barrier/Input Leap pour le partage souris/clavier entre OS
- [ ] Configurer ddcutil pour le switch d'entrée moniteur entre GPUs
