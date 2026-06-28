{ config, pkgs, ... }:

{
  imports = [
    ./plasma.nix
    ./vscode.nix
  ];

  home.username      = "etienne";
  home.homeDirectory = "/home/etienne";
  home.stateVersion  = "25.05";

  programs.home-manager.enable = true;

  home.sessionVariables = {
    EDITOR        = "code --wait";
    NIXOS_OZONE_WL = "1";   # VSCode natif Wayland
  };
}
