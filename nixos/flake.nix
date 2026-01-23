{
  description = "NixOS from Scratch";
  inputs = {
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-25.11";
    };
    nixpkgs.url = "nixpkgs/nixos-25.11";
  };
  outputs =
    {
      home-manager,
      nixpkgs,
      self,
      ...
    }:
    {
      nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager
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
