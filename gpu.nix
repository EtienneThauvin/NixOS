{ config, pkgs, ... }:

{
  # ============================================================================
  # DRIVERS GPU
  # RTX 5070 (GB205) → driver Nvidia open (requis pour GB205+)
  # GTX 1050 Ti (GP107) → nouveau via service systemd
  #   (legacy, non supportée par driver 595.xx)
  # ============================================================================
  services.xserver.videoDrivers = [ "nvidia" "nouveau" ];

  hardware.nvidia = {
    modesetting.enable = true;
    open               = true;
    nvidiaSettings     = true;
    package            = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics.enable = true;

  # NixOS blackliste nouveau automatiquement quand Nvidia est actif.
  # Ce service le force après le chargement de Nvidia.
  systemd.services.load-nouveau = {
    description = "Load nouveau for GTX 1050 Ti";
    after       = [ "systemd-modules-load.service" ];
    wantedBy    = [ "multi-user.target" ];
    serviceConfig = {
      Type            = "oneshot";
      ExecStart       = "${pkgs.kmod}/bin/modprobe nouveau";
      RemainAfterExit = true;
    };
  };
}
