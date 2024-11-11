{ pkgs, config, libs, ... }:
{
  services.tailscale = {
    enable = true;
  };
}
