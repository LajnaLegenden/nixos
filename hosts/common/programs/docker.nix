{ pkgs, config, libs, ... }:
{
virtualisation.docker.enable = true;
users.extraGroups.docker.members = [ "lajna" ];
  virtualisation.docker.rootless = {
  enable = true;
  setSocketVariable = true;
};
}

