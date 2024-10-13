{ pkgs, config, libs, ... }:

{
 programs.streamdeck-ui = {
    enable = true;
    autoStart = true; # optional
  };
}