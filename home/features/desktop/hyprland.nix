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
        inputs.hyprland-plugins.packages.${pkgs.system}.csgo-vulkan-fix
      ];

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

        exec-once = [
          "waybar"
          "kdeconnect-indicator"
          "hyprctl dispatch workspace 1"
          "nm-applet"
          "ulauncher --hide-window"
          "swww-daemon"
          ".config/hypr/set_random_wallpaper.sh"
          "eval $(ssh-agent)"
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
          gaps_in = 5;
          gaps_out = 20;
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";
          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          rounding = 10;
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };
        };

        animations = {
          enabled = true;
          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
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
        };

        "windowrule" = [
          "opacity 1.0 1.0,class:.*"
          "opacity 0.8 0.8,class:.*,floating:0,fullscreen:0"
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
          "$mainMod, R, exec, ulauncher-toggle"
          "$mainMod, T, exec, firefox "
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
          "$mainMod, W, togglespecialworkspace, magic"
          "$mainMod SHIFT, W, movetoworkspace, special:magic"
          "$mainMod, mouse_down, workspace, e+1"
          "$mainMod, mouse_up, workspace, e-1"
          "$mainMod SHIFT, I, exec, ~/.config/hypr/set_random_wallpaper.sh"
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
            onResume = "brightnessctl -r";
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
