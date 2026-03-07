{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # programs.zsh.enable = true;
      # programs.zsh.interactiveShellInit = ''
      #   # eval "$(/opt/homebrew/bin/brew shellenv)"
      # '';
      programs.zsh.interactiveShellInit = ''
        if test -f /etc/profile; then
          source /etc/profile
        fi
      '';

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Set primary user for user-specific options
      system.primaryUser = "atupadhy";

      system.defaults = {
        dock = {
          autohide = true;
          persistent-apps = [
            "/Applications/Slack.app"
            "/Applications/Google Chrome.app"
            "/Applications/Brave Browser.app"
            "/Applications/Cursor.app"
            "/Applications/Obsidian.app"
            "/Applications/WhatsApp.app"
          ];
        };
        finder.ShowPathbar = true;
        NSGlobalDomain."com.apple.swipescrolldirection" = true;
      };

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    darwinConfigurations."atupadhy-mac" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    homeConfigurations."atupadhy" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages."aarch64-darwin";
      modules = [ ./home.nix ];
    };
  };
}
