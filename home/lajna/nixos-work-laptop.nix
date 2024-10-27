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
    wallpaper.enable=true;
    vesktop.enable = false;
    thunderbird.enable = true;
    spotify.enable = true;
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
        "desc:Dell Inc. DELL S2722QC CQ7JMD3,3840x2160@60,0x0,1.5"
        "desc:California Institute of Technology 0x1404,1920x1200@60,3840x1200,1"
        "desc:AOC AG271QG 0x01010101,2560x1440@60,-2560x0,1"
        #        "desc:AOC AG271QG \#ASNglWnZ7sjd,2560x1440@165.00,0x0,1"
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
        #   "5, monitor:desc:AOC AG271QG #ASNglWnZ7sjd"
        #"6, monitor:desc:AOC AG271QG #ASNglWnZ7sjd"
        #      "7, monitor:desc:AOC AG271QG #ASNglWnZ7sjd"
        # "8, monitor:desc:AOC AG271QG #ASNglWnZ7sjd"
        "9, monitor:desc:California Institute of Technology 0x1404"
        "10, monitor:desc:California Institute of Technology 0x1404"
              ];
    };
  };


  }
