# Linux (Fedora)

## Build and Activate

```bash
home-manager switch --flake .#cnavajas@fedora
```

## Check Store Size

```bash
# Total Nix store size
du -sh /nix/store

# Dry run - see what can be freed
nix-collect-garbage --dry-run

# List generations
home-manager generations

# Show largest packages
nix path-info -rsSh ~/.nix-profile | sort -hk2 | tail -20
```

## Garbage Collection

```bash
nix-collect-garbage -d
```

## Update Packages

```bash
nix flake update
home-manager switch --flake .#cnavajas@fedora
```
