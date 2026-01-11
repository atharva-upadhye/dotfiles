{ config, pkgs, ... }: {
	home.username = "atharva";
	home.homeDirectory = "/home/atharva";
	home.stateVersion = "25.11";
	home.packages = with pkgs; [
		neovim
	];
	programs.alacritty = {
		enable = true;
		# This wraps the binary with the environment variable
		# doing this is important since GPU config is not working out of the box for alacritty
		package = (pkgs.alacritty.overrideAttrs (oldAttrs: {
			nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ pkgs.makeWrapper ];
			postInstall = (oldAttrs.postInstall or "") + ''
			wrapProgram $out/bin/alacritty \
				--set LIBGL_ALWAYS_SOFTWARE 1
			'';
		}));
		
		settings = {
			# Your usual alacritty settings here
			font.size = 12;
		};
	};
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

