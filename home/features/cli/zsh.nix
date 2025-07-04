{
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.features.cli.zsh;
in
{
  options.features.cli.zsh.enable = mkEnableOption "enable extended zsh configuration";

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      envExtra = "
      NIX_PATH=nixpkgs=channel:nixos-unstable
      NIX_LOG=info
      ";
      initContent = lib.mkBefore ''
        # P10k instant prompt
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        # Zinit setup
        ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"
        if [ ! -d "$ZINIT_HOME" ]; then
          mkdir -p "$(dirname $ZINIT_HOME)"
          git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
        fi
        source "''${ZINIT_HOME}/zinit.zsh"
        # Essential immediate-load plugins
        zinit ice depth=1
        zinit light romkatv/powerlevel10k

        # Deferred plugins
        zinit ice wait lucid
        zinit light zsh-users/zsh-syntax-highlighting

        zinit ice wait lucid
        zinit light zsh-users/zsh-completions

        zinit ice wait'0a' lucid
        zinit light zsh-users/zsh-autosuggestions

        zinit ice wait lucid
        zinit light Aloxaf/fzf-tab

        # Deferred snippets
        zinit ice wait lucid
        zinit snippet OMZL::history.zsh

        for snippet in git sudo; do
          zinit ice wait lucid
          zinit snippet OMZP::$snippet
        done

        zinit cdreplay -q

        # Load p10k config
        [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

        # Basic keybindings
        bindkey -e
        bindkey '^p' history-search-backward
        bindkey '^n' history-search-forward
        bindkey '^[w' kill-region

        # Deferred completion styling
        zinit ice wait lucid
        zinit light %HOME/.config/zsh/completion-config
      '';
      shellAliases = {
        ".." = "cd ..";
        "..." = "cd ../..";
        ls = "eza";
        grep = "rg";
        ps = "procs";
        yui = "yarn upgrade-interactive --latest && yarn-dedupe && yarn";
        cd = "z";
        cat = "bat";
        rebuildSystem = "sudo nixos-rebuild switch --flake /home/lajna/nixConfig/";
        gcam = "git commit --amend --no-edit";
        gitClean = "git pull -p && git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D && git branch | wc -l";
        ":q" = "echo 'ARE YOU STOOOPID, THIS IS NOT A FILE'";
        ":wq" = "echo 'ARE YOU STOOOPID, THIS IS NOT A FILE, WHAT ARE YOU SAVING?'";
        grm = "git fetch origin && git rebase origin/master";
        vim = "nvim";
        vi = "nvim";
        v = "nvim";
      };
    };
  };
}
