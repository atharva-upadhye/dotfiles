{
  config,
  pkgs,
  ...
}:
{
  home = {
    file = {
      ".config/qtile" = {
        recursive = true;
        source = ./config/qtile;
      };
      ".config/nvim" = {
        recursive = true;
        source = ./config/nvim;
      };
    };
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
  xresources = {
    properties = {
      "XTerm*background" = "black";
      "XTerm*foreground" = "white";
    };
  };
}
