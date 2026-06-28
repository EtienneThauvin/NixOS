{ ... }:

{
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/653343a6-d72e-4929-988a-9d4801f951bf";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B196-AF2C";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/data" =
    { device = "/dev/disk/by-uuid/eac06185-9fd8-4e38-a41b-59c9c028e540";
      fsType = "ext4";
    };

  swapDevices = [ ];

  systemd.tmpfiles.rules = [
    "d /data 0755 etienne users -"
  ];
}
