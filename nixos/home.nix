{
  config,
  pkgs,
  ...
}:
let
  dotfilesDir = "${config.home.homeDirectory}/_/gh/atharva-upadhye/dotfiles";
in
{
  home = {
    homeDirectory = "/home/atharva";
    file = builtins.listToAttrs (map (name: { 
      inherit name;
      value = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/${name}"; 
        recursive = true;
      };
    }) [ ".gitconfig" ".gitignore_global" ]) // {
      "_/sh" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/sh";
        recursive = true;
      };
    };
    packages = with pkgs; [
      gcc
      fzf
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
      shellOptions = [
        "histappend"
        "extglob"
        "globstar"
        "checkjobs"
      ];
      historyControl = [ "ignoredups" "ignorespace" ];
      historySize = 10000;
      historyFileSize = 100000;
      initExtra = ''
        alias btw='echo I use nixos, btw'
        
        # Source common shell functions
        [[ -f "$HOME/_/sh/sh.sh" ]] && . "$HOME/_/sh/sh.sh"
        
        # Source bash-specific configurations
        [[ -f "$HOME/_/sh/bash.sh" ]] && . "$HOME/_/sh/bash.sh"
      '';
    };
    brave = {
      enable = true;
      package = pkgs.brave;
      # extensions = [ { id = ""; }];
    };
    fzf = {
      enableBashIntegration = true;
    };
    git = {
      enable = true;
    };
  };
  xdg = {
    configFile = builtins.listToAttrs (map (name: { 
      inherit name; 
      value = { 
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/${name}"; 
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
