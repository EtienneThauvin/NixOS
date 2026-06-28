{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./network.nix
    ./gpu.nix
    ./desktop.nix
    ./packages.nix
  ];

  # ============================================================================
  # BOOT
  # ============================================================================
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.extraModprobeConfig = ''
    options nouveau modeset=1
  '';

  # ============================================================================
  # LOCALE & TIMEZONE
  # ============================================================================
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";

  # ============================================================================
  # UTILISATEUR
  # ============================================================================
  users.users.etienne = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" "docker" "libvirtd" "kvm" "disk" ];
    shell = pkgs.bash;
  };

  security.sudo.wheelNeedsPassword = true;

  # ============================================================================
  # NIX
  # ============================================================================
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";

  programs.nix-ld.enable = true;
}
