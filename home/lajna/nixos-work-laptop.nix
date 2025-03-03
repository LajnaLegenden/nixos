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
      env.enable = true;
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
      chrome.enable = true;
      theme.enable = true;
      dunst = {
        enable = false;
        colorFile = "$HOME/.cache/wal/colors.sh";
        # You can add more custom settings here if needed
      };
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
      monitor = [
        "desc:California Institute of Technology 0x1404,1920x1200@60,2560x800,1"
        "desc:AOC AG271QG 0x01010101,2560x1440@60,-1440x0,1, transform , 1"
        "desc:Agilent Technologies 1080p60     0x00000001,1920x1080@60,-1080x0,1, transform , 1"
        "desc:HP Inc. HP X34 6CM15009MZ,3440x1440@75,0x0,1"
        "desc:Hewlett Packard HP LE2202x CNT229P1PZ,1920x1080@60,760x-1080,1"
        "desc:Hewlett Packard HP LE2202x CNT22720C6,1920x1080@60,-1080x180,1,transform,3"
        "desc:Dell Inc. DELL S2722QC CQ7JMD3,3840x2160@60,0x0,1.5"
      ];
      workspace = [
        "1, monitor:desc:Dell Inc. DELL S2722QC CQ7JMD3, default:true"
        "2, monitor:desc:Dell Inc. DELL S2722QC CQ7JMD3"
        "3, monitor:desc:Dell Inc. DELL S2722QC CQ7JMD3"
        "4, monitor:desc:Dell Inc. DELL S2722QC CQ7JMD3"
        "5, monitor:desc:AOC AG271QG 0x01010101"
        "6, monitor:desc:AOC AG271QG 0x01010101"
        "7, monitor:desc:AOC AG271QG 0x01010101"
        "8, monitor:desc:AOC AG271QG 0x01010101"
        "5, monitor:desc:AOC AG271QG #ASNglWnZ7sjd"
        "6, monitor:desc:AOC AG271QG #ASNglWnZ7sjd"
        "7, monitor:desc:AOC AG271QG #ASNglWnZ7sjd"
        "8, monitor:desc:AOC AG271QG #ASNglWnZ7sjd"
        "9, monitor:desc:California Institute of Technology 0x1404"
        "10, monitor:desc:California Institute of Technology 0x1404"
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
