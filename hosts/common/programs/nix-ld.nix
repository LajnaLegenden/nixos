{ config, pkgs, ... }:
{
  # Configure nix-ld with comprehensive library support using Steam runtime
  programs.nix-ld = {
    enable = true;
    libraries = [
      # Use Steam's comprehensive runtime libraries
      # This provides a battle-tested collection of libraries that work with
      # thousands of applications without needing to manually maintain a list
      (pkgs.runCommand "steam-runtime-libs" { } ''
        mkdir -p $out
        ln -s ${pkgs.steam-run.fhsenv}/usr/lib64 $out/lib
      '')
    ];
  };
}
