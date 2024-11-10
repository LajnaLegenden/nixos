{pkgs, config,...}: {
  imports = [
    ./zsh.nix
    ./fzf.nix
    ./neofetch.nix
    ./dev.nix
    ./env.nix
  ];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    enableBashIntegration = true;
    extraOptions = ["-l" "--icons" "--git" "-a"];
  };

  programs.bat = {enable = true;};

  home.packages = with pkgs; [
    coreutils
    fd
    htop
    httpie
    jq
    procs
    ripgrep
    tldr
    zip
    btop
    tree
  ];

   programs.kitty.extraConfig = ''
      include ${config.xdg.cacheHome}/wal/colors-kitty.conf
    '';

    programs.zsh.initExtra = ''
      # Import colorscheme from 'wal' asynchronously
      # &   # Run the process in the background.
      # ( ) # Hide shell job control messages.
      (cat ${config.xdg.cacheHome}/wal/sequences &)
    '';
}
