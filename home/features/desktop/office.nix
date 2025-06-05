{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

{
  home.packages = [
    pkgs.libreoffice
    pkgs.filezilla
  ];
}
