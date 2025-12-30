# Dotfiles

This repository contains my personal dotfiles configuration. All configuration folders are symlinked into `~/.config/` for easy management and version control.

## Structure

Each folder in this repository represents a configuration directory that will be symlinked into `~/.config/`. For example:

- `waybar/` → `~/.config/waybar`
- `hyprland/` → `~/.config/hyprland`
- `nvim/` → `~/.config/nvim`

## Setup

### Initial Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/skordaschristofanis/dotfiles.git ~/repos/dotfiles
   cd ~/repos/dotfiles
   ```

2. Run the linking script:
   ```bash
   ./link-dotfiles.sh
   ```

### Adding New Configurations

Simply add a new folder to this repository and run the linking script again:

```bash
mkdir myapp
# Add your configuration files to myapp/
./link-dotfiles.sh
```

The script will automatically detect and link the new folder to `~/.config/myapp`.

## Usage

### Basic Linking

Link all folders (skips existing files/links):
```bash
./link-dotfiles.sh
```

### Options

- **Force overwrite**: Overwrite existing files or symlinks
  ```bash
  ./link-dotfiles.sh --force
  ```

- **Backup existing**: Backup existing files before linking
  ```bash
  ./link-dotfiles.sh --backup
  ```

- **Verbose output**: Show detailed information about each operation
  ```bash
  ./link-dotfiles.sh --verbose
  ```

- **Help**: Show usage information
  ```bash
  ./link-dotfiles.sh --help
  ```

## How It Works

The `link-dotfiles.sh` script:

1. Scans the repository for all directories
2. Skips hidden directories (starting with `.`)
3. Creates symlinks from `~/.config/<folder>` to the repository folders
4. Handles existing files/links based on the options provided

## Notes

- Hidden directories (starting with `.`) are automatically skipped
- The script will not overwrite existing files unless you use `--force` or `--backup`
- All symlinks are relative, so the repository can be moved without breaking links
