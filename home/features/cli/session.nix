# Add this to your home.nix or a separate module

{ config, pkgs, ... }:

{
  # Make sure tmux and fzf are installed, optionally add fd for better gitignore support
  home.packages = with pkgs; [
    tmux
    fzf
    fd # fd respects .gitignore automatically and is faster than find
  ];

  # Create the tmux-sessionizer script
  home.file.".local/bin/tmux-sessionizer" = {
    text = ''
            #!/usr/bin/env bash
                  CONFIG_DIR="''${XDG_CONFIG_HOME:-$HOME/.config}/tmux-sessionizer"
                  CONFIG_FILE="$CONFIG_DIR/tmux-sessionizer.conf"

            # test if the config file exists
                  if [[ -f "$CONFIG_FILE" ]]; then
            # shellcheck source=/dev/null
                    source "$CONFIG_FILE"
                      fi

                      sanity_check() {
                        if ! command -v tmux &>/dev/null; then
                          echo "tmux is not installed. Please install it first."
                            exit 1
                            fi
                            if ! command -v fzf &>/dev/null; then
                              echo "fzf is not installed. Please install it first."
                                exit 1
                                fi
                      }

                switch_to() {
                  if [[ -z $TMUX ]]; then
                    tmux attach-session -t "$1"
                  else
                    tmux switch-client -t "$1"
                      fi
                }

                kill_session() {
                  local session_name="$1"
                  if has_session "$session_name"; then
                    tmux kill-session -t "$session_name"
                    echo "Killed session: $session_name"
                  else
                    echo "Session '$session_name' does not exist"
                    exit 1
                  fi
                }

                list_sessions_for_kill() {
                  tmux list-sessions -F "#{session_name}" 2>/dev/null | \
                    while read -r session_name; do
                      echo "[KILL] $session_name"
                    done
                }
      create_session_with_layout() {
          local session_name="''$1"
          local session_path="''$2"
          
          # Create new session with first window (this will be the nvim window)
          tmux new-session -ds "''$session_name" -c "''$session_path" -n "nvim"
          
          # Open nvim in the first window
          tmux send-keys -t "''$session_name:nvim" "nvim" C-m
          
          # Create a second window for terminal
          tmux new-window -t "''$session_name" -n "terminal" -c "''$session_path"
          
          # Focus on the terminal window
          tmux select-window -t "''$session_name:terminal"
          
          # Run hydrate function if it exists
          hydrate "''$session_name" "''$session_path"
      }
                has_session() {
                  tmux list-sessions | grep -q "^$1:"
                }

                hydrate() {
                  if [ -f "$2/.tmux-sessionizer" ]; then
                    tmux send-keys -t "$1" "source $2/.tmux-sessionizer" c-M
                      elif [ -f "$HOME/.tmux-sessionizer" ]; then
                      tmux send-keys -t "$1" "source $HOME/.tmux-sessionizer" c-M
                      fi
                }

                sanity_check

            # if TS_SEARCH_PATHS is not set use default
                  [[ -n "$TS_SEARCH_PATHS" ]] || TS_SEARCH_PATHS=(~/ ~/personal ~/personal/dev/env/.config)

            # Add any extra search paths to the TS_SEARCH_PATHS array
                  if [[ ''${#TS_EXTRA_SEARCH_PATHS[@]} -gt 0 ]]; then
                    TS_SEARCH_PATHS+=("''${TS_EXTRA_SEARCH_PATHS[@]}")
                      fi

            # utility function to find directories
            # utility function to find directories
                      find_dirs() {
            # list TMUX sessions with their working directories
                        if [[ -n "''${TMUX}" ]]; then
                          current_session=$(tmux display-message -p '#S')
                            tmux list-sessions -F "#{session_name} #{session_path}" 2>/dev/null | \
                            grep -v "^''$current_session " | \
                            while read -r session_name session_path; do
                              if [[ -n "''$session_path" && "''$session_path" != "/" ]]; then
                                project_name=$(basename "''$session_path")
                                  echo "[TMUX] ''$project_name"
                              else
                                echo "[TMUX] ''$session_name"
                                  fi
                                  done
                        else
                          tmux list-sessions -F "#{session_name} #{session_path}" 2>/dev/null | \
                            while read -r session_name session_path; do
                              if [[ -n "''$session_path" && "''$session_path" != "/" ]]; then
                                project_name=$(basename "''$session_path")
                                  echo "[TMUX] ''$project_name"
                              else
                                echo "[TMUX] ''$session_name"
                                  fi
                                  done
                                  fi

                                  for entry in "''${TS_SEARCH_PATHS[@]}"; do
            # Check if entry as :number as suffix then adapt the maxdepth parameter
                                    if [[ "''$entry" =~ ^([^:]+):([0-9]+)$ ]]; then
                                      path="''${BASH_REMATCH[1]}"
                                        depth="''${BASH_REMATCH[2]}"
                                    else
                                      path="''$entry"
                                        fi
                                        if [[ -d "''$path" ]]; then
                                          if command -v fd &>/dev/null; then
                                            fd -H --type d --type f --max-depth "''${depth:-''${TS_MAX_DEPTH:-1}}" '^\.git$' "''$path" --exec dirname {} \;
                                          else
                                            find "''$path" -mindepth 2 -maxdepth "$((''${depth:-''${TS_MAX_DEPTH:-1}} + 1))" -name ".git" \( -type d -o -type f \) -exec dirname {} \;
                        fi
                          fi
                          done
                      }

                # Handle command line arguments
                if [[ $# -eq 1 ]]; then
                  if [[ "$1" == "--kill" || "$1" == "-k" ]]; then
                    # Kill mode: show only existing sessions
                    if ! tmux list-sessions &>/dev/null; then
                      echo "No tmux sessions found"
                      exit 0
                    fi
                    selected=$(list_sessions_for_kill | fzf --prompt="Select session to kill: ")
                    if [[ -z $selected ]]; then
                      exit 0
                    fi
                    # Extract session name from [KILL] prefix
                    if [[ "$selected" =~ ^\[KILL\]\ (.+)$ ]]; then
                      session_name="''${BASH_REMATCH[1]}"
                      kill_session "$session_name"
                      exit 0
                    fi
                  elif [[ "$1" == "--help" || "$1" == "-h" ]]; then
                    echo "tmux-sessionizer - A tmux session manager"
                    echo ""
                    echo "Usage:"
                    echo "  tmux-sessionizer              # Interactive session selection"
                    echo "  tmux-sessionizer <path>       # Create/switch to session at path"
                    echo "  tmux-sessionizer --kill       # Kill existing session"
                    echo "  tmux-sessionizer -k           # Kill existing session (short)"
                    echo "  tmux-sessionizer --help       # Show this help"
                    echo "  tmux-sessionizer -h           # Show this help (short)"
                    exit 0
                  else
                    selected="$1"
                  fi
                else
                  selected=$(find_dirs | fzf --preview 'if [[ -d "{}" && -d "{}/.git" ]]; then echo "=== Git Status ==="; cd "{}" && git status --short --branch 2>/dev/null; echo; fi; exa -l --color=always {}')
                fi

                    if [[ -z $selected ]]; then
                      exit 0
                        fi
                        if [[ "''$selected" =~ ^\[TMUX\]\ (.+)$ ]]; then
                          project_name="''${BASH_REMATCH[1]}"
            # Find the actual session name that corresponds to this project
                            session_name=$(tmux list-sessions -F "#{session_name} #{session_path}" 2>/dev/null | \
                                while read -r sess_name sess_path; do
                                if [[ -n "''$sess_path" && "''$sess_path" != "/" ]]; then
                                if [[ "$(basename "''$sess_path")" == "''$project_name" ]]; then
                                echo "''$sess_name"
                                break
                                fi
                                elif [[ "''$sess_name" == "''$project_name" ]]; then
                                echo "''$sess_name"
                                break
                                fi
                                done)
                            selected="''$session_name"
                            fi
                            selected_name=$(basename "$selected" | tr . _)
                            tmux_running=$(pgrep tmux)

                            if [[ -z ''$TMUX ]] && [[ -z ''$tmux_running ]]; then
        create_session_with_layout "''$selected_name" "''$selected"
      fi

      if ! has_session "''$selected_name"; then
        create_session_with_layout "''$selected_name" "''$selected"
      fi

                                    switch_to "$selected_name"
    '';
    executable = true;
  };

  # Create the config file
  home.file.".config/tmux-sessionizer/tmux-sessionizer.conf" = {
    text = ''
        # tmux-sessionizer configuration
        # Search in your code directory with deeper depth to find git projects
        TS_SEARCH_PATHS=(~/code:4)

      # Set max depth for searching (adjust if you have deeper nested projects)
        TS_MAX_DEPTH=4

        # Optional: Add other common code directories if you have them
        # TS_EXTRA_SEARCH_PATHS=(~/projects:3 ~/dev:3 ~/work:3)
    '';
  };

  # Configure tmux with the keybinding
  programs.tmux = {
    enable = true;
  };

  # Optional: Add shell alias for easy access
  programs.bash.shellAliases = {
    ts = "~/.local/bin/tmux-sessionizer";
  };

  programs.zsh.shellAliases = {
    ts = "~/.local/bin/tmux-sessionizer";
  };
}
