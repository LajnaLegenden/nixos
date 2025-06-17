{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.desktop.hyprland;
in
{
  options.features.desktop.hyprland.enable = mkEnableOption "hyprland config";

  config = mkIf cfg.enable {
    home.file = {
      ".config/hypr/generate_hyprlock_config.sh" = {
        source = ../../scripts/hyprlock.sh; # Path to your script file
        executable = true;
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.default;
      plugins = [
        #        inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
      ];
      extraConfig = ''
              source = ${config.xdg.configHome}/hypr/colors.conf
              $color8 = $on_primary_fixed
        $color11 = $on_surface
      '';
      sourceFirst = true;
      settings = {
        cursor = {
          no_hardware_cursors = true;
        };

        plugin = {
          csgo-vulkan-fix = {
            res_w = 2560;
            res_h = 1440;

            # NOT a regex! This is a string and has to exactly match initial_class
            class = "cs2";

            # Whether to fix the mouse position. A select few apps might be wonky with this.
            fix_mouse = true;
          };
        };

        "$color8" = "$on_primary_fixed";
        "$color11" = "$on_surface";

        exec-once = [
          "hypridle"
          "waybar"
          "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
          "discord"
          "kdeconnect-indicator"
          "hyprctl dispatch workspace 1"
          "nm-applet"
          "ulauncher --hide-window"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "QT_QPA_PLATFORM=wayland albert"
          "swww-daemon"
          ".config/hypr/set_random_wallpaper.sh"
          "eval $(ssh-agent)"
          "$HOME/.config/waybar/launch.sh"
          "$HOME/.config/scripts/gtk.sh"
        ];
        source = [
          "${config.xdg.configHome}/hypr/colors.conf"
        ];

        env = [
          "XCURSOR_SIZE,32"
          "GTK_THEME,Dracula"
          "AQ_DRM_DEVICES,/dev/dri/card1:/dev/dri/card2"
          "XDG_SESSION_TYPE,wayland"
          "ELECTRON_OZONE_PLATFORM_HINT,auto"
        ];
        input = {
          kb_layout = "se";
          follow_mouse = 1;
          kb_options = "meta:nocaps";
          touchpad = {
            natural_scroll = false;
          };
          sensitivity = 0;
        };

        general = {
          gaps_in = 10;
          gaps_out = 14;
          border_size = 3;
          "col.active_border" = "$color11";
          "col.inactive_border" = "$color8";
          layout = "dwindle";
          resize_on_border = true;
        };

        decoration = {
          rounding = 10;
          shadow.enabled = false;
          blur = {
            enabled = false;
            size = 3;
            passes = 1;
          };
        };

        animations = {
          enabled = true;
          # Animation curves
          bezier = [
            "linear, 0, 0, 1, 1"
            "md3_standard, 0.2, 0, 0, 1"
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "overshot, 0.05, 0.9, 0.1, 1.1"
            "crazyshot, 0.1, 1.5, 0.76, 0.92"
            "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
            "easeInOutCirc, 0.85, 0, 0.15, 1"
            "easeOutCirc, 0, 0.55, 0.45, 1"
            "easeOutExpo, 0.16, 1, 0.3, 1"
            "softAcDecel, 0.26, 0.26, 0.15, 1"
            "md2, 0.4, 0, 0.2, 1" # use with .2s duration
          ];

          # Animation configs
          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "windowsIn, 1, 3, md3_decel, popin 60%"
            "windowsOut, 1, 3, md3_accel, popin 60%"
            "border, 1, 10, default"
            "fade, 1, 3, md3_decel"
            # "layers, 1, 2, md3_decel, slide"
            "layersIn, 1, 3, menu_decel, slide"
            "layersOut, 1, 1.6, menu_accel"
            "fadeLayersIn, 1, 2, menu_decel"
            "fadeLayersOut, 1, 4.5, menu_accel"
            "workspaces, 1, 7, menu_decel, slide"
            # "workspaces, 1, 2.5, softAcDecel, slide"
            # "workspaces, 1, 7, menu_decel, slidefade 15%"
            # "specialWorkspace, 1, 3, md3_decel, slidefadevert 15%"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        gestures = {
          workspace_swipe = false;
        };

        misc = {
          force_default_wallpaper = -1;
          vfr = true;
        };

        "windowrule" = [
          "opacity 1.0 1.0,class:.*"
          "opacity 1.0 0.7,class:^(kitty)$"
        ];

        windowrulev2 = "suppressevent maximize, class:.*";

        "$mainMod" = "SUPER";

        bind = [
          "$mainMod, Q, exec, alacritty"
          "$mainMod, C, killactive,"
          "$mainMod, M, exit,"
          "$mainMod, E, exec, thunar"
          "$mainMod, V, togglefloating,"
          "$mainMod, R, exec, albert toggle"
          "$mainMod, T, exec, brave"
          "$mainMod, U, pseudo,"
          "$mainMod, P, exec, hyprlock"
          "$mainMod, I, togglesplit,"
          "$mainMod, left, movefocus, l"
          "$mainMod, H, movefocus, l"
          "$mainMod, right, movefocus, r"
          "$mainMod, L, movefocus, r"
          "$mainMod, up, movefocus, u"
          "$mainMod, K, movefocus, u"
          "$mainMod, down, movefocus, d"
          "$mainMod, J, movefocus, d"
          "$mainMod SHIFT, S, exec, grim -g \"$(slurp)\" - | wl-copy"
          "$mainMod, N, exec, swaync-client -t -sw"
          # Resize windows
          "$mainMod ALT, left, resizeactive, -40 0"
          "$mainMod ALT, right, resizeactive, 40 0"
          "$mainMod ALT, up, resizeactive, 0 -40"
          "$mainMod ALT, down, resizeactive, 0 40"
          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"
          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"
          "$mainMod CTRL, H, movecurrentworkspacetomonitor, l"
          "$mainMod CTRL, L, movecurrentworkspacetomonitor, r"
          "$mainMod, W, togglespecialworkspace, magic"
          "$mainMod SHIFT, W, movetoworkspace, special:magic"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          "$mainMod SHIFT, I, exec, ~/.config/hypr/set_random_wallpaper.sh"
          "$mainMod SHIFT, R, exec,  ~/.sh/restartAll.sh"
          "$mainMod SHIFT, P, exec, wlogout"
          # Media controls
          ", XF86AudioPlay, exec, playerctl play-pause"
          ", XF86AudioNext, exec, playerctl next"
          ", XF86AudioPrev, exec, playerctl previous"

          ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5% && ~/.sh/volume.sh"
          ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5% && ~/.sh/volume.sh"
          ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle && ~/.sh/volume.sh"

          # Brightness control
          ", XF86MonBrightnessUp, exec, brightnessctl set +5% && ~/.sh/brightness.sh"
          ", XF86MonBrightnessDown, exec, brightnessctl set 5%- && ~/.sh/brightness.sh"
        ];

        binde = [
          "$mainMod ALT, left, resizeactive, -40 0"
          "$mainMod ALT, right, resizeactive, 40 0"
          "$mainMod ALT, up, resizeactive, 0 -40"
          "$mainMod ALT, down, resizeactive, 0 40"
        ];

        workspace = [
          "w[t1], gapsout:0, gapsin:0, border:0, rounding:0"
          "w[tg1], gapsout:0, gapsin:0, border:0, rounding:0"
        ];
        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };

    };
    home.packages = with pkgs; [
      swaynotificationcenter
      brightnessctl
    ];

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lockCmd = "pidof hyprlock || hyprlock";
          beforeSleepCmd = "loginctl lock-session";
          afterSleepCmd = "hyprctl dispatch dpms on";
        };
        listeners = [
          {
            timeout = 150;
            onTimeout = "brightnessctl -s set 10";
          }
          {
            timeout = 150;
            onTimeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            onResume = "brightnessctl -rd rgb:kbd_backlight";
          }
          {
            timeout = 300;
            onTimeout = "loginctl lock-session";
          }
          {
            timeout = 380;
            onTimeout = "hyprctl dispatch dpms off";
            onResume = "hyprctl dispatch dpms on";
          }
          {
            timeout = 1800;
            onTimeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}
