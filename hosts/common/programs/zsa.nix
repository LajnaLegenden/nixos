
{ pkgs, config, libs, ... }:

{
     environment.systemPackages = with pkgs; [
  zsa-udev-rules
  keymapp
];
}
