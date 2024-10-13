{
  config,
  pkgs,
  inputs,
  ...
}: {
  users.users.lajna = {
    initialHashedPassword = "$y$j9T$qeHII9xOEYpec3fzFPbjP0$49EmQlnZBVIgvm6rN4ha7f/l7qB.OtfU1wHuE4C7if2";
    isNormalUser = true;
    description = "Linus";
    extraGroups = [
      "wheel"
      "networkmanager"
      "libvirtd"
      "flatpak"
      "audio"
      "video"
      "plugdev"
      "input"
      "kvm"
      "qemu-libvirtd"
    ];
    packages = [inputs.home-manager.packages.${pkgs.system}.default];
  };
  home-manager.users.lajna =
    import lajna/${config.networking.hostName}.nix;
}
