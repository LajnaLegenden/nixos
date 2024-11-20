{ pkgs, config, libs, ... }:

{
     virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = [ "lajna" ]; 
   virtualisation.virtualbox.host.enableExtensionPack = true;
 
}
