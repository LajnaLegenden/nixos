{ config, ... }:
{
  imports = [
    ./home.nix
    ../common
    ../features/cli
    ../features/desktop
  ];

  features = {
    cli = {
      zsh.enable = true;
      fzf.enable = true;
      neofetch.enable = true;
      tmux.enable = true;
      dev = {
        enable = true;
        isWorkMachine = false; # Set to false for personal machines
      };
    };

    desktop = {
      wayland.enable = true;
      hyprland.enable = true;
      fonts.enable = true;
      firefox.enable = true;
      vesktop.enable = true;
      wallpaper.enable = true;
      obsidian.enable = true;
      chrome.enable = true;
      spotify.enable = true;
      theme.enable = true;
      slack.enable = true;
      gammastep.enable = true;
      dunst = {
        enable = false;
        colorFile = "$HOME/.cache/wal/colors.sh";
        # You can add more custom settings here if needed
      };

    };
  };

  wayland.windowManager.hyprland = {
    settings = {
      env = [
          "WLR_NO_HARDWARE_CURSORS,1"
          "GBM_BACKEND,nvidia-drm"
          "LIBVA_DRIVER_NAME,nvidia"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
      monitor = [
        "desc:HP Inc. HP X34 6CM15009MZ,3440x1440@165,0x0,1"
        "desc:LG Electronics LG ULTRAGEAR 009NTUW40494,2560x1440@143.97,3440x0,1"
        "desc:Hewlett Packard HP LE2202x CNT229P1PZ,1920x1080@60,760x-1080,1"
        "desc:Hewlett Packard HP LE2202x CNT22720C6,1920x1080@60,-1080x180,1,transform,3"
      ];
      workspace = [
        "1, monitor:desc:HP Inc. HP X34 6CM15009MZ, default:true"
        "2, monitor:desc:HP Inc. HP X34 6CM15009MZ"
        "3, monitor:desc:HP Inc. HP X34 6CM15009MZ"
        "4, monitor:desc:HP Inc. HP X34 6CM15009MZ"
        "5, monitor:desc:LG Electronics LG ULTRAGEAR 009NTUW40494"
        "6, monitor:desc:LG Electronics LG ULTRAGEAR 009NTUW40494"
        "7, monitor:desc:Hewlett Packard HP LE2202x CNT229P1PZ"
        "8, monitor:desc:Hewlett Packard HP LE2202x CNT229P1PZ"
        "9, monitor:desc:Hewlett Packard HP LE2202x CNT22720C6"
      ];
    };
  };

}
