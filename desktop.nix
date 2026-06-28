{ pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.xkb.layout = "fr";
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  security.rtkit.enable = true;
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  services.pipewire.alsa.support32Bit = true;
  services.pipewire.pulse.enable = true;

  services.pipewire.extraConfig.pipewire."99-swap-channels" = {
    "context.modules" = [
      {
        name = "libpipewire-module-loopback";
        args = {
          "node.description" = "Analog Stereo Swapped";
          "capture.props" = {
            "node.name" = "swap_input";
            "media.class" = "Audio/Sink";
            "audio.position" = [ "FL" "FR" ];
          };
          "playback.props" = {
            "node.name" = "swap_output";
            "audio.position" = [ "FR" "FL" ];
            "target.object" = "alsa_output.pci-0000_0c_00.6.analog-stereo";
          };
        };
      }
    ];
  };

  services.pipewire.wireplumber.extraConfig."99-default-sink" = {
    "wireplumber.settings" = {
      "default.audio.sink" = "swap_input";
    };
  };

  services.displayManager.sddm.settings = {
    X11 = {
      ServerArguments = "-nolisten tcp";
    };
  };

  environment.etc."sddm/Xsetup".source = pkgs.writeShellScript "Xsetup" ''
    xrandr --output DP-2 --primary --mode 2560x1440 --rate 180 \
          --output HDMI-A-3 --off
  '';
}
