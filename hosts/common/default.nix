# Common configuration for all hosts

{ pkgs, lib, inputs, outputs, ... }:
 {
  imports = [
    ./users
    ./programs
    inputs.home-manager.nixosModules.home-manager
  ];
  environment.systemPackages = with pkgs; [
  hyprpolkitagent
 ];
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs;};
  };
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.additions
      outputs.overlays.modifications
      outputs.overlays.stable-packages

      # You can also add overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [
        "root"
        "lajna"
      ]; # Set users that are allowed to use the flake command
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
    optimise.automatic = true;
    registry = (lib.mapAttrs (_: flake: { inherit flake; }))
      ((lib.filterAttrs (_: lib.isType "flake")) inputs);
    nixPath = [ "/etc/nix/path" ];
  };
  users.defaultUserShell = pkgs.zsh;
#Rebind caps to super for hyprland
 # For X11
  services.xserver = {
    xkbOptions = "caps:super";
  };

  # For Wayland
  services.interception-tools = {
    enable = true;
    plugins = [ pkgs.interception-tools-plugins.caps2esc ];
    udevmonConfig = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc -m 1 | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_LEFTMETA]
    '';
  };

  security = {
    polkit.enable = true;
    pam.services.hyprlock = {};
  };
  programs.ssh = {
    startAgent = true;
    # Optional: set how long keys should be remembered
    agentTimeout = "infinity"; # Or "infinity" for no timeout
  };

   programs.ssh.extraConfig = ''
    AddKeysToAgent yes
    
    # Optional: Configure specific keys
    Host *
      IdentityFile ~/.ssh/id_ed25519
      # Add more IdentityFile lines for other keys
  '';         
 }
