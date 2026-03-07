{ ... }:
{
  environment.systemPackages = with pkgs; [
    waybar
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
  programs = {
    xdg = {
      configFile = builtins.listToAttrs (map (name: { 
        inherit name; 
        value = { 
          source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/${name}"; 
          recursive = true; 
        }; 
      }) [ "nvim" "alacritty" "rofi" "oxwm" "sway" "hypr" "waybar" ]);
    };
    xresources = {
      properties = {
        "XTerm*background" = "black";
        "XTerm*foreground" = "white";
      };
    };
  };
}