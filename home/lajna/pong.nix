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
      tmux.enable = false;
      env.enable = false;
      dev = {
        enable = true;
        isWorkMachine = true; # Set to false for personal machines
      };
    };

    desktop = {
      wayland.enable = true;
      hyprland.enable = true;
      fonts.enable = true;
      firefox.enable = true;
      obsidian.enable = true;
      slack.enable = true;
      wallpaper.enable = true;
      vesktop.enable = true;
      thunderbird.enable = true;
      spotify.enable = true;
      clickup.enable = true;
      chrome.enable = false;
      theme.enable = true;
      connect.enable = true;
      gammastep.enable = true;
    };
  };

  wayland.windowManager.hyprland = {

    extraConfig = ''
      windowrulev2 = workspace 9 silent,class:^(Slack)$
           windowrulev2 = workspace 10 silent,class:^(thunderbird)$
    '';
    settings = {
      exec-once = [
        "blueman-applet"
        "thunderbird"
        "slack"
      ];
      debug = {
        disable_logs = false;
      };
      env = [
      "AQ_NO_MODIFIERS,1"
      ];
                   monitor = [
        "desc:AU Optronics 0x9EA9,1920x1200@60,4720x890,1"
        "desc:Hewlett Packard HP LE2202x CNT22720C6,1920x1080@60,4720x-1030,1, transform , 3"
        "desc:HP Inc. HP X34 6CM15009MZ,3440x1440@60,5800x-790,1"
        "desc:Samsung Electric Company LC27G5xT HK2W401603,2560x1440@120,9240x-790,1"
        "desc:Dell Inc. DELL S2722QC CQ7JMD3,3840x2160@60,0x0,1, transform , 1"
        "desc:AOC AG271QG ##ASNglWnZ7sjd,2560x1440@120,2160x720,1"
      ];
      workspace = [
        "7, monitor:desc:Dell Inc. DELL S2722QC CQ7JMD3, default:true"
        "8, monitor:desc:Dell Inc. DELL S2722QC CQ7JMD3"
        "6, monitor:desc:Dell Inc. DELL S2722QC CQ7JMD3"
        "5, monitor:desc:Dell Inc. DELL S2722QC CQ7JMD3"
        "1, monitor:desc:AOC AG271QG 0x01010101"
        "2, monitor:desc:AOC AG271QG 0x01010101"
        "3, monitor:desc:AOC AG271QG 0x01010101"
        "4, monitor:desc:AOC AG271QG 0x01010101"
        "1, monitor:desc:AOC AG271QG ##ASNglWnZ7sjd"
        "2, monitor:desc:AOC AG271QG ##ASNglWnZ7sjd"
        "3, monitor:desc:AOC AG271QG ##ASNglWnZ7sjd"
        "4, monitor:desc:AOC AG271QG ##ASNglWnZ7sjd"
        "9, monitor:desc:AU Optronics 0x9EA9"
        "10, monitor:desc:AU Optronics 0x9EA9"
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
