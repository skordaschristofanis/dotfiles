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

Configs in `config/` are symlinked into `~/.config/` by home-manager. Each host profile (`modules/home-modules/<host>.nix`) chooses which configs to link.

## Setup

### Clone with submodules

```bash
git clone --recurse-submodules git@github.com:skordaschristofanis/dotfiles.git ~/repos/dotfiles
cd ~/repos/dotfiles
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
```

Only the `.example` templates in `secrets/` are committed. `nix flake check --impure` is required so Nix can read secrets from your home directory.

### NixOS (hellios)

1. Create secrets (see above).

2. Verify and apply:
   ```bash
   nix flake check --impure
   sudo nixos-rebuild switch --flake ~/repos/dotfiles#hellios
   ```

### macOS (vortex)

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

2. Link it in the relevant home profile (`modules/home-modules/hellios.nix`, etc.):
   ```nix
   (import ./lib/link-configs.nix {
     inherit dotfiles;
     configs = [ "nvim" "myapp" ];
   })
   ```

3. Rebuild.
