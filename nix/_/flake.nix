{
  description = "main flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    systemArch = "aarch64-darwin";
    username = "atupadhy";
    host = "mac"; # mac or nixos-fs
  in
  {
    darwinConfigurations."${username}-mac" = nix-darwin.lib.darwinSystem {
      modules = [
        ./system.nix
        ./os/darwin.nix
      ];
      specialArgs = { 
        inherit self systemArch username;
      };
    };
    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${systemArch};
      modules = [ ./home.nix ];
      extraSpecialArgs = {
        inherit host username;
      };
    };
  };
}
