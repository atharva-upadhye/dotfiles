
{
	description = "NixOS from Scratch";
	inputs = {
		nixpkgs.url = "nixpkgs/nixos-25.11";
		home-manager = {
			url = "github:nix-community/home-manager/release-25.11";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};
	outputs = { self, nixpkgs, home-manager, ... }: {
		nixosConfigurations.nixos-btw = nixpkgs.lib.nixosSystem {
			system = "aarch64-darwin";
			modules = [
				./configuration.nix
				home-manager.nixosModules.home-manager
				{
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
						users.atharva = import ./home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}

