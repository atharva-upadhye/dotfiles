{ config, host, pkgs, username, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/_/dotfiles";
  mkSymlinks = targetBase: names: builtins.listToAttrs (
    map (name: {
      inherit name;
      value = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/config/${name}";
        target = "${targetBase}/${name}";
        recursive = true;
      };
    }) names
  );
in
{
  home = {
    inherit username;
    homeDirectory = if host == "mac"
      then "/Users/${username}"
      else if host == "nixos-fs"
      then "/home/${username}"
      else throw "Unsupported host: ${host}";
    file = mkSymlinks config.home.homeDirectory [ 
      ".gitconfig"
      ".gitignore" 
    ] // mkSymlinks "${config.home.homeDirectory}/.config" [
      "nvim"
      # "alacritty"
    ];
    packages = with pkgs; [
      fd # alt of find
      # # font-awesome
      # fzf # also brew
      # just # alt of make
      neovim # alt of vim
      # nil # nix language server & analyzer
      # nixfmt
      opencode
      # ripgrep # alt of grep, also brew
      # tmux # also brew
      tree
      yq # alt of jq, for JSON, YAML, INI, XML
    ] ++ (
      if host == "nixos-fs" then [
        gcc
        vim
      ] else if host == "mac" then [
      ] else throw "Unsupported host: ${host}"
    );
    stateVersion = "24.11";
  };
  programs = {
  } // (
    if host == "mac" then {
    } else if host == "nixos-fs" then {
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
          [[ -f "$HOME/_/sh/sh.sh" ]] && . "$HOME/_/sh/sh.sh"
        '';
      };
    } else throw "Unsupported host: ${host}"
  );
}
