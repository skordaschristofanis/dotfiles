# Dotfiles

Personal system configuration managed with Nix flakes (NixOS + nix-darwin) and home-manager.

## Structure

```
dotfiles/
├── config/              # App configs (git submodules), linked via home-manager
│   └── nvim/            # → ~/.config/nvim
├── hosts/               # Per-machine settings (modules, hardware)
├── modules/             # Shared NixOS/darwin/home-manager modules
└── secrets/             # Example templates for ~/.secrets/nix/
```

Configs in `config/` are symlinked into `~/.config/` by home-manager (`config/nvim` → `~/.config/nvim`). Each host profile (`modules/home-modules/<host>.nix`) chooses which configs to link.

## Setup

### Clone with submodules

```bash
git clone --recurse-submodules git@github.com:skordaschristofanis/dotfiles.git
cd dotfiles
```

If already cloned without submodules:

```bash
git submodule update --init --recursive
```

### Secrets

Each host has a secrets file at `~/.secrets/nix/<hostname>.nix` (outside the repo) for **identity** — username, git name/email, and SSH key paths. Which apps/modules are enabled live in each host file under `hosts/`.

```bash
mkdir -p ~/.secrets/nix
cp secrets/hellios.nix.example ~/.secrets/nix/hellios.nix   # NixOS (home)
cp secrets/vortex.nix.example ~/.secrets/nix/vortex.nix     # macOS (work)

# optional: system-wide symlink so sudo rebuilds find secrets reliably
sudo mkdir -p /etc/nix-secrets
sudo ln -sf ~/.secrets/nix/hellios.nix /etc/nix-secrets/hellios.nix
```

Only the `.example` templates in `secrets/` are committed. Secrets and config submodules live outside the nix store, so always pass `--impure` to `nixos-rebuild` and `nix flake check`.

### NixOS

1. Create secrets (see above).

2. Verify and apply:
   ```bash
   nix flake check --impure
   sudo nixos-rebuild switch --flake /repos/dotfiles#hellios --impure
   ```

### macOS

1. Create secrets (see above).

2. Install Nix and apply (use `sudo -H` if needed):
   ```bash
   curl -fsSL https://install.determinate.systems/nix | sh -s -- install
   nix flake check --impure ~/Repos/dotfiles
   nix run nix-darwin/nix-darwin-26.05#darwin-rebuild -- switch --flake ~/Repos/dotfiles#vortex
   ```

   On subsequent rebuilds, `darwin-rebuild switch --flake ~/Repos/dotfiles#vortex` works once nix-darwin is installed.

## Adding a config

1. Add a submodule (or directory) under `config/`:
   ```bash
   git submodule add git@github.com:you/repo.git config/myapp
   ```

2. Set `host.dotfilesPath` in the host file and link configs in the home profile:
   ```nix
   # hosts/nixos/hellios/default.nix
   host.dotfilesPath = "/repos/dotfiles";

   # modules/home-modules/hellios.nix
   (import ./lib/link-configs.nix {
     inherit dotfilesPath;
     configs = [ "nvim" "myapp" ];
   })
   ```

   Uses `home.file` with `mkOutOfStoreSymlink` so git submodules work (they are not in the nix store).

3. Rebuild.
