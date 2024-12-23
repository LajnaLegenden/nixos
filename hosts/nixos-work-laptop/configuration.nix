# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs,... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-work-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  programs.zsh.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "se";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "sv-latin1";

  # Enable CUPS to print documents.
  services.printing.enable = true;
  #Eanble kolide
  environment.etc."kolide-k2/secret" = {
      mode = "0600";
      text = "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJvcmdhbml6YXRpb24iOiJuYWdvamEiLCJraWQiOiJiODoxZDowNjo5NzpjYjo3OTpjMDo3MTpjNDoxNTpjZDo5Yzo4Mjo0MDo4NjpjYSIsImNyZWF0ZWRBdCI6IjE3MjgwMjUxMTkiLCJjcmVhdGVkQnkiOiJrd29ya2VyIn0.WrePAfMFWx987FKi4rAb1lADcHYMBQkC0Hl6G2SvJ7IwvffkQxUSFCl5-cGnanVvWZStMleY-XV1IwEHEqd9sHjE_e2p2Dx9ZBxvRmWb6ywS1y5PwOv7foymJesdn8xu_jOMcT4hn-48q-HSg37TnrT3XJIDt0geIQ5bQaahSSZF9iuT1pdy8mgUDbVWDvpEZazp9icdGirJICYV6EmuaPz-mRK9JNtRzMQeTzBMLJv8LMfY5hAKQHdEeTVgHTP_nPS8ldxUuT46miXcHtucHKUyEKQlSyNDVO53WI9eDU16PysNXsMruQbXPDMG74rbVkkiSlnXynX1JvE0rlUJww";
    };
  services.kolide-launcher.enable = true;
    
  #Enable bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  services.blueman.enable = true;
  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lajna = {
    isNormalUser = true;
    description = "Linus";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
      fprintd
    ];
  };
  services.fprintd.enable = true;

services.fprintd.tod.enable = true;

services.fprintd.tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

    hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vpl-gpu-rt          # for newer GPUs on NixOS >24.05 or unstable
      # onevpl-intel-gpu  # for newer GPUs on NixOS <= 24.05
      # intel-media-sdk   # for older GPUs
    ];
  };

  # List packages installed in system profile. To search, run:

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
