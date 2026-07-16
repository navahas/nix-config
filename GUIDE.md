# /guide

```
sudo darwin-rebuild switch --flake .#setup

nix-collect-garbage --delete-older-than 10

nix-env --list-generations --profile /nix/var/nix/profiles/system

nix-env --profile /nix/var/nix/profiles/system --delete-generations +5

home-manager switch --flake .#navahas@devlab
```

