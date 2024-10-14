{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.features.desktop.dunst;
in
{
  options.features.desktop.dunst = {
    enable = mkEnableOption "Dunst with custom colors";

    package = mkOption {
      type = types.package;
      default = pkgs.dunst;
      description = "The Dunst package to use.";
    };

    colorFile = mkOption {
      type = types.str;
      default = "$HOME/.cache/wal/colors.sh";
      description = "Path to the color file to source.";
    };

    settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Additional settings for Dunst configuration.";
    };
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      package = cfg.package;
      settings = mkMerge [
        cfg.settings
        {
          global = {
            follow = "mouse";
            geometry = "300x5-30+20";
            indicate_hidden = "yes";
            shrink = "no";
            transparency = 0;
            notification_height = 0;
            separator_height = 2;
            padding = 8;
            horizontal_padding = 8;
            frame_width = 3;
            frame_color = "#aaaaaa";
            separator_color = "frame";
            sort = "yes";
            idle_threshold = 120;
            font = "Monospace 8";
            line_height = 0;
            markup = "full";
            format = "<b>%s</b>\n%b";
            alignment = "left";
            show_age_threshold = 60;
            word_wrap = "yes";
            ellipsize = "middle";
            ignore_newline = "no";
            stack_duplicates = "true";
            hide_duplicate_count = "false";
            show_indicators = "yes";
            icon_position = "left";
            max_icon_size = 32;
            sticky_history = "yes";
            history_length = 20;
            dmenu = "/usr/bin/dmenu -p dunst:";
            browser = "/usr/bin/firefox -new-tab";
            always_run_script = "true";
            title = "Dunst";
            class = "Dunst";
            startup_notification = "false";
            verbosity = "mesg";
            corner_radius = 0;
          };
        }
      ];
    };

    home.file.".config/dunst/launch-dunst.sh" = {
      text = ''
        #!/bin/sh

        [ -f "${cfg.colorFile}" ] && . "${cfg.colorFile}"

        pidof dunst && killall dunst

        ${cfg.package}/bin/dunst \
          -lf  "''${color0:-#ffffff}" \
          -lb  "''${color1:-#eeeeee}" \
          -lfr "''${color2:-#dddddd}" \
          -nf  "''${color3:-#cccccc}" \
          -nb  "''${color4:-#bbbbbb}" \
          -nfr "''${color5:-#aaaaaa}" \
          -cf  "''${color6:-#999999}" \
          -cb  "''${color7:-#888888}" \
          -cfr "''${color8:-#777777}" > /dev/null 2>&1 &
      '';
      executable = true;
    };

    systemd.user.services.dunst-custom-colors = {
      Unit = {
        Description = "Dunst notification daemon with custom colors";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${config.home.homeDirectory}/.config/dunst/launch-dunst.sh";
        Restart = "always";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}