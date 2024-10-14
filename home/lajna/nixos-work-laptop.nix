{ config, ... }: { 
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
    dev = {
      enable = true;
      isWorkMachine = true;  # Set to false for personal machines
    };
  };

  desktop = {
    wayland.enable = true;
    hyprland.enable = true;
    fonts.enable = true;
    firefox.enable =true;
    slack.enable = true;
    vesktop.enable = false;
    thunderbird.enable = true;
    dunst = {
      enable = true;
      colorFile = "$HOME/.cache/wal/colors.sh";
      # You can add more custom settings here if needed
    };
  };
 };
 
    wayland.windowManager.hyprland = {
    settings = {
       exec-once = [
          "blueman-applet"
          "thunderbird"
          "slack"
        ];
      monitor = [
        "desc:Dell Inc. DELL S2722QC CQ7JMD3,3840x2160@60,-3840x0,1"
        "desc:California Institute of Technology 0x1404,1920x1200@60,2560x200,1"
        "desc:AOC AG271QG 0x01010101,2560x1440@60,0x0,1"
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
        "9, monitor:desc:California Institute of Technology 0x1404"
        "0, monitor:desc:California Institute of Technology 0x1404"
              ];
    };
  };


  }
