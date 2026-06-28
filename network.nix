{ config, pkgs, ... }:

{
  networking = {
    hostName              = "nixbox";
    networkmanager.enable = true;

    # Bridge pour la VM (sera utilisé dans vm.nix)
    bridges.br0.interfaces = [ "enp10s0u2" ];
    interfaces.br0         = {};
  };
}
