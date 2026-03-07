{ pkgs, self, systemArch, username, ... }:
{
  environment.systemPackages = with pkgs; [
    home-manager
    git # also brew
  ];
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  nix.settings.experimental-features = "nix-command flakes";
  nixpkgs.hostPlatform = systemArch;
  programs = {
    zsh.interactiveShellInit = ''
      if test -f /etc/profile; then
        source /etc/profile
      fi
    '';
  };
  system = {  
    configurationRevision = self.rev or self.dirtyRev or null;
    primaryUser = username;
    stateVersion = 6;
  };
}
