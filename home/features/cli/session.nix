{ config, pkgs, ... }:

let
  tmux-sessionizer = pkgs.writeShellScriptBin "tmux-sessionizer" ''
    CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/tmux-sessionizer"
    CONFIG_FILE="$CONFIG_DIR/tmux-sessionizer.conf"

    # test if the config file exists
    if [[ -f "$CONFIG_FILE" ]]; then
        source "$CONFIG_FILE"
    fi

    sanity_check() {
        if ! command -v ${pkgs.tmux}/bin/tmux &>/dev/null; then
            echo "tmux is not installed. Please install it first."
            exit 1
        fi
        if ! command -v ${pkgs.fzf}/bin/fzf &>/dev/null; then
            echo "fzf is not installed. Please install it first."
            exit 1
        fi
    }

    switch_to() {
        if [[ -z $TMUX ]]; then
            ${pkgs.tmux}/bin/tmux attach-session -t "$1"
        else
            ${pkgs.tmux}/bin/tmux switch-client -t "$1"
        fi
    }

    has_session() {
        ${pkgs.tmux}/bin/tmux list-sessions | ${pkgs.gnugrep}/bin/grep -q "^$1:"
    }

    hydrate() {
        if [ -f "$2/.tmux-sessionizer" ]; then
            ${pkgs.tmux}/bin/tmux send-keys -t "$1" "source $2/.tmux-sessionizer" c-M
        elif [ -f "$HOME/.tmux-sessionizer" ]; then
            ${pkgs.tmux}/bin/tmux send-keys -t "$1" "source $HOME/.tmux-sessionizer" c-M
        fi
    }

    sanity_check

    [[ -n "$TS_SEARCH_PATHS" ]] || TS_SEARCH_PATHS=(~/ ~/personal ~/personal/dev/env/.config)

    if [[ ''${#TS_EXTRA_SEARCH_PATHS[@]} -gt 0 ]]; then
        TS_SEARCH_PATHS+=("''${TS_EXTRA_SEARCH_PATHS[@]}")
    fi

    find_dirs() {
        if [[ -n "''${TMUX}" ]]; then
            current_session=$(${pkgs.tmux}/bin/tmux display-message -p '#S')
            ${pkgs.tmux}/bin/tmux list-sessions -F "[TMUX] #{session_name}" 2>/dev/null | ${pkgs.gnugrep}/bin/grep -vFx "[TMUX] $current_session"
        else
            ${pkgs.tmux}/bin/tmux list-sessions -F "[TMUX] #{session_name}" 2>/dev/null
        fi
        
        for entry in "''${TS_SEARCH_PATHS[@]}"; do
            if [[ "$entry" =~ ^([^:]+):([0-9]+)$ ]]; then
                path="''${BASH_REMATCH[1]}"
                depth="''${BASH_REMATCH[2]}"
            else
                path="$entry"
            fi
            [[ -d "$path" ]] && ${pkgs.findutils}/bin/find "$path" -mindepth 1 -maxdepth "''${depth:-''${TS_MAX_DEPTH:-1}}" -path '*/.git' -prune -o -type d -print
        done
    }

    if [[ $# -eq 1 ]]; then
        selected="$1"
    else
        selected=$(find_dirs | ${pkgs.fzf}/bin/fzf)
    fi

    if [[ -z $selected ]]; then
        exit 0
    fi

    if [[ "$selected" =~ ^\[TMUX\]\ (.+)$ ]]; then
        selected="''${BASH_REMATCH[1]}"
    fi

    selected_name=$(${pkgs.coreutils}/bin/basename "$selected" | ${pkgs.coreutils}/bin/tr . _)
    tmux_running=$(${pkgs.procps}/bin/pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        ${pkgs.tmux}/bin/tmux new-session -ds "$selected_name" -c "$selected"
        hydrate "$selected_name" "$selected"
    fi

    if ! has_session "$selected_name"; then
        ${pkgs.tmux}/bin/tmux new-session -ds "$selected_name" -c "$selected"
        hydrate "$selected_name" "$selected"
    fi

    switch_to "$selected_name"
  '';

in {
  home.packages = [ tmux-sessionizer ];

  # Create the config file
  home.file.".config/tmux-sessionizer/tmux-sessionizer.conf" = {
    text = ''
      TS_SEARCH_PATHS=(~/code:4)
      TS_MAX_DEPTH=4
    '';
  };

  programs.tmux = {
    enable = true;
    extraConfig = ''
      bind-key -r f run-shell 'tmux neww tmux-sessionizer'
    '';
  };

  programs.bash.shellAliases.ts = "tmux-sessionizer";
  programs.zsh.shellAliases.ts = "tmux-sessionizer";
}
