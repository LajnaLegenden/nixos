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

      # Basic settings
      prefix = "C-Space";
      keyMode = "vi";
      mouse = true;

      # Plugin configuration
      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        yank
        {
          plugin = pkgs.tmuxPlugins.mkTmuxPlugin {
            pluginName = "onedarkpro-tmux";
            version = "unstable-2025-06-19"; # Update this date as needed
            src = pkgs.fetchFromGitHub {
              owner = "EvanZhouDev";
              repo = "onedarkpro-tmux";
              rev = "35f21c262655b995db75fd34a09296cb6ec23153"; # or specific commit hash for reproducibility
              sha256 = "sha256-zCNIFsagH5UwhAuFMbdGjgXa601SS7ApnC/k4JGHYMQ="; # Leave empty first, nix will tell you the correct hash
            };
            rtpFilePath = "onedarkpro.tmux"; # This tells it the correct filename
          };
        }
      ];

      # Additional configuration
      extraConfig = ''
        # Terminal overrides for true color
        set-option -sa terminal-overrides ",xterm*:Tc"

        # Unbind default prefix and set new one
        unbind C-b
        bind C-Space send-prefix

        # Vim style pane selection
        bind h select-pane -L
        bind j select-pane -D 
        bind k select-pane -U
        bind l select-pane -R

        # Start windows and panes at 1, not 0
        set -g base-index 1
        set -g pane-base-index 1
        set-window-option -g pane-base-index 1
        set-option -g renumber-windows on

        # Use Alt-arrow keys without prefix key to switch panes
        bind -n M-Left select-pane -L
        bind -n M-Right select-pane -R
        bind -n M-Up select-pane -U
        bind -n M-Down select-pane -D

        # Shift arrow to switch windows
        bind -n S-Left  previous-window
        bind -n S-Right next-window

        # Shift Alt vim keys to switch windows
        bind -n M-H previous-window
        bind -n M-L next-window

        # Vi-mode keybindings
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
        bind-key v copy-mode

        # Custom keybindings
        bind-key -r f run-shell 'tmux neww ~/.local/bin/tmux-sessionizer'
        bind '"' split-window -v -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"

        set -g @catppuccin_flavour 'mocha'
        run-shell ${pkgs.tmuxPlugins.catppuccin}/share/tmux-plugins/catppuccin/catppuccin.tmux
      '';
    };
  };
}
