# Common configuration for all hosts

{
  pkgs,
  lib,
  inputs,
  outputs,
  ...
}:
{
  imports = [
    ./users
    ./programs
    inputs.home-manager.nixosModules.home-manager
  ];
  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    inputs.zen-browser.packages."${system}".specific
    inputs.ghostty.packages.x86_64-linux.default

  ];
  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs outputs; };
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
    registry = (lib.mapAttrs (_: flake: { inherit flake; })) (
      (lib.filterAttrs (_: lib.isType "flake")) inputs
    );
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
    pam.services.hyprlock = { };
    pam.services.sddm.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;

  # Add environment variables for SSH askpass
  environment = {
    variables = {
      SSH_AUTH_SOCK = lib.mkForce "/run/user/\${UID}/keyring/ssh";
      SSH_ASKPASS = lib.mkForce "${pkgs.seahorse}/libexec/seahorse/ssh-askpass";
    };
  };
  systemd = {
    # Fix opening links in apps like vscode
    user.extraConfig = ''
      DefaultEnvironment="PATH=/run/current-system/sw/bin:/run/wrappers/bin:/var/lib/flatpak/exports/bin:/nix/profile/bin:/etc/profiles/per-user/masum/bin:/nix/var/nix/profiles/default/bin:/home/masum/.local/share/applications/"
    '';
    # Polkit starting systemd service - needed for apps requesting root access
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };
  # disable firewall
  networking.firewall.enable = false;
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
