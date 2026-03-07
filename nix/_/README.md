# how to use

rebuild home manager
```sh
home-manager switch --flake ~/_/dotfiles/nix/_
```

rebuild macos
```sh
sudo darwin-rebuild switch --flake ~/_/dotfiles/nix/_#atupadhy-mac
```

## others

List packages installed in system profile. To search by name, run:
```sh
nix-env -qaP
```