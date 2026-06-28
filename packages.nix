{ config, pkgs, ... }:

{
  # ============================================================================
  # PACKAGES SYSTÈME
  # ============================================================================
  environment.systemPackages = with pkgs; [
    # Desktop
    firefox
    gimp
    vlc
    audacity
    freecad
    vscode
    claude-code

    # Dev
    python3
    gcc
    gnumake
    git

    # Système
    htop
    pciutils
    wget
    curl
    unzip
    p7zip

    mission-center
  ];

  # ============================================================================
  # STEAM
  # ============================================================================
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
  };

  # ============================================================================
  # DOCKER
  # ============================================================================
  virtualisation.docker.enable = true;

  # ============================================================================
  # FLATPAK — Bambu Lab Studio
  # ============================================================================
  services.flatpak.enable = true;
  # Après install :
  #   flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  #   flatpak install flathub com.bambulab.BambuStudio
}
