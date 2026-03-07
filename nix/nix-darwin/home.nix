{ config, pkgs, ... }:
let
  dotfilesDir = "${config.home.homeDirectory}/_/dotfiles";
in
{
  home = {
    homeDirectory = "/Users/atupadhy";
    packages = with pkgs; [
      fd
      font-awesome
      fzf
      git
      just
      neovim
      ripgrep
      tmux
      tree
      vim
      yq
    ];
    stateVersion = "24.11";
    username = "atupadhy";
  };
  programs = {
    home-manager = {
      enable = true;
    };
  };
}
