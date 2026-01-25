{
  description = "NixOS from Scratch";
  inputs = {
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.11";
    };
    nixpkgs.url = "nixpkgs/nixos-25.11";
    oxwm = {
      url = "github:tonybanters/oxwm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      home-manager,
      nixpkgs,
      self,
      oxwm,
      ...
    }:
    {
      nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
          oxwm.nixosModules.default
          {
            home-manager = {
              backupFileExtension = "backup";
              useGlobalPkgs = true;
              users.atharva = import ./home.nix;
              useUserPackages = true;
            };
          }
        ];
        system = "aarch64-darwin";
      };

      # Standalone Home Manager configuration (no sudo needed)
      homeConfigurations.atharva = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "aarch64-linux";
        };
        modules = [ ./home.nix ];
      };
    };
}
