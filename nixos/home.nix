{ config, pkgs, ... }: {
	home.username = "atharva";
	home.homeDirectory = "/home/atharva";
	home.stateVersion = "25.11";
	home.packages = with pkgs; [
		neovim
	];
	programs.brave = {
		enable = true;
		package = pkgs.brave;
		# extensions = [ { id = ""; }];
	};
	programs.git.enable = true;
	programs.bash = {
		enable = true;
		shellAliases = {
			btw = "echo I use nixos, btw";
		};
	};
	xresources.properties = {
		"XTerm*background" = "black";
		"XTerm*foreground" = "white";
	};
}

