{
  config,
  pkgs,
  ...
}:
let
  dotfilesDir = "${config.home.homeDirectory}/gh/atharva-upadhye/dotfiles/config";
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
      # This wraps the binary with the environment variable
      # doing this is important since GPU config is not working out of the box for alacritty
      (
        alacritty.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or [ ]) ++ [ makeWrapper ];
          postInstall = (oldAttrs.postInstall or "") + ''
            wrapProgram $out/bin/alacritty \
            	--set LIBGL_ALWAYS_SOFTWARE 1
          '';
        })
      )
    ];
    stateVersion = "25.11";
    username = "atharva";
  };
  programs = {
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
    configFile = builtins.listToAttrs (map (name: { 
      inherit name; 
      value = { 
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/${name}"; 
        recursive = true; 
      }; 
    }) [ "nvim" "alacritty" "rofi" "oxwm" ]);
  };
  xresources = {
    properties = {
      "XTerm*background" = "black";
      "XTerm*foreground" = "white";
    };
  };
}
