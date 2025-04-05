{
  description = ''
    For questions just DM me on X: https://twitter.com/@m3tam3re
    There is also some NIXOS content on my YT channel: https://www.youtube.com/@m3tam3re

    One of the best ways to learn NIXOS is to read other peoples configurations. I have personally learned a lot from Gabriel Fontes configs:
    https://github.com/Misterio77/nix-starter-configs
    https://github.com/Misterio77/nix-config

    Please also check out the starter configs mentioned above.
  '';

  inputs = {
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    };
    nixos-hardware = {
      url = "github:NixOS/nixos-hardware/master";
    };
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    nixpkgs-stable = {
      url = "github:nixos/nixpkgs/nixos-23.11";
    };
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
    };
    kolide-launcher = {
      url = "github:/kolide/nix-agent/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      home-manager,
      nixpkgs,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      inherit (self) outputs;
      systems = [
        "aarch64-linux"
        "i686-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      overlays = import ./overlays { inherit inputs; };
      nixosConfigurations = let
        # Common modules shared across all systems
        commonModules = [
          inputs.kolide-launcher.nixosModules.kolide-launcher
        ];
        
        # Map of system-specific configurations
        systemConfigs = {
          nixos-gaming = {
            modules = [
              ./hosts/nixos-gaming
            ];
          };
          nixos-work-laptop = {
            modules = [
              inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-11th-gen
              ./hosts/nixos-work-laptop  
            ];
          };
          nixos-gaming-laptop = {
            modules = [
              ./hosts/nixos-gaming-laptop
            ];
          };
        };

      in
        builtins.mapAttrs (hostname: config: 
          nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs outputs; };
            modules = commonModules ++ config.modules;
          }
        ) systemConfigs;
      homeConfigurations = builtins.mapAttrs
        (hostname: _: home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages."x86_64-linux";
          extraSpecialArgs = { inherit inputs outputs; };
          modules = [
            ./home/lajna/${hostname}.nix
          ];
        })
        {
          "lajna@nixos-gaming" = {};
          "lajna@nixos-work-laptop" = {};
          "lajna@nixos-gaming-laptop" = {};
        };
    };
}
