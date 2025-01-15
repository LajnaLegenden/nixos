{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.features.cli.tmux;
in
{
  options.features.cli.tmux.enable = mkEnableOption "enable tmux";

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      tmux
    ];
    programs.tmux = {
      enable = true;

      baseIndex = 1;
      prefix = "C-K";

      plugins = [
        pkgs.tmuxPlugins.better-mouse-mode
        pkgs.tmuxPlugins.sensible
        pkgs.tmuxPlugins.vim-tmux-navigator
        pkgs.tmuxPlugins.yank
      ];

      extraConfig = ''
        set -g default-terminal "tmux-256color"
        set-option -sa terminal-overrides ",xterm*:Tc"
        set -g mouse on
        bind -n M-h select-pane -L
        bind -n M-j select-pane -D
        bind -n M-k select-pane -U
        bind -n M-l select-pane -R

        bind -n M-H previous-window
        bind -n M-L next-window

        # Shift arrow to switch windows
        bind -n S-Left  previous-window
        bind -n S-Right next-window

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window
          # set vi-mode
        set-window-option -g mode-keys vi
        # keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
      '';
    };

  };
}
