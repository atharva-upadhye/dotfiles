{
  config,
  pkgs,
  ...
}:
let
  dotfilesDirectory = "${config.home.homeDirectory}/gh/atharva-upadhye/dotfiles";
in
{
  home = {
    homeDirectory = "/home/atharva";
    packages = with pkgs; [
      gcc
      neovim
      nil
      nixfmt
      tree
      ripgrep
      # wget
    ];
    stateVersion = "25.11";
    username = "atharva";
  };
  programs = {
    alacritty = {
      enable = true;
      # This wraps the binary with the environment variable
      # doing this is important since GPU config is not working out of the box for alacritty
      package = (
        pkgs.alacritty.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ pkgs.makeWrapper ];
          postInstall = (oldAttrs.postInstall or "") + ''
            wrapProgram $out/bin/alacritty \
            	--set LIBGL_ALWAYS_SOFTWARE 1
          '';
        })
      );

      settings = {
        # Your usual alacritty settings here
        font = {
          size = 10;
        };
      };
    };
    bash = {
      enable = true;
      shellAliases = {
        btw = "echo I use nixos, btw";
      };
    };
    brave = {
      enable = true;
      package = pkgs.brave;
      # extensions = [ { id = ""; }];
    };
    git = {
      enable = true;
    };
  };
  xdg = {
    configFile = {
      "qtile" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/nixos/config/qtile";
        recursive = true;
      };
      "nvim" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDirectory}/nixos/config/nvim";
        recursive = true;
      };
    };
  };
  xresources = {
    properties = {
      "XTerm*background" = "black";
      "XTerm*foreground" = "white";
    };
  };
}
