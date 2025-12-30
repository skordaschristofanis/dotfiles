#!/usr/bin/env bash
#
# Generic script to symlink dotfiles folders into ~/.config/
# Usage: ./link-dotfiles.sh [options]
#
# Options:
#   -f, --force    Force overwrite existing files/directories
#   -b, --backup   Backup existing files/directories before linking
#   -v, --verbose  Verbose output
#   -h, --help     Show this help message

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default options
FORCE=false
BACKUP=false
VERBOSE=false

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$HOME/.config"

# Help message
show_help() {
    cat << EOF
Usage: $0 [OPTIONS]

Symlink all folders from the dotfiles repository into ~/.config/

OPTIONS:
    -f, --force     Force overwrite existing files/directories
    -b, --backup    Backup existing files/directories before linking
    -v, --verbose   Verbose output
    -h, --help      Show this help message

EXAMPLES:
    $0                  # Link all folders, skip existing
    $0 --force          # Force overwrite existing links/directories
    $0 --backup         # Backup existing before linking
    $0 --verbose        # Show detailed output

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--force)
            FORCE=true
            shift
            ;;
        -b|--backup)
            BACKUP=true
            shift
            ;;
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo -e "${RED}Unknown option: $1${NC}" >&2
            show_help
            exit 1
            ;;
    esac
done

# Logging functions
log_info() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[INFO]${NC} $1"
    fi
}

log_success() {
    echo -e "${GREEN}[OK]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Check if config directory exists, create if not
if [[ ! -d "$CONFIG_DIR" ]]; then
    log_info "Creating $CONFIG_DIR"
    mkdir -p "$CONFIG_DIR"
fi

# Function to create symlink
create_symlink() {
    local source="$1"
    local target="$2"
    local folder_name="$3"
    
    # Check if target already exists
    if [[ -e "$target" ]] || [[ -L "$target" ]]; then
        if [[ -L "$target" ]]; then
            local current_link="$(readlink "$target")"
            if [[ "$current_link" == "$source" ]]; then
                log_info "Symlink already exists and points to correct location: $target"
                return 0
            else
                log_warning "Symlink exists but points to different location: $target -> $current_link"
                if [[ "$FORCE" == true ]]; then
                    log_info "Removing existing symlink: $target"
                    rm "$target"
                elif [[ "$BACKUP" == true ]]; then
                    log_info "Backing up existing symlink: $target -> ${target}.backup"
                    mv "$target" "${target}.backup"
                else
                    log_warning "Skipping $folder_name (use --force to overwrite or --backup to backup)"
                    return 1
                fi
            fi
        else
            log_warning "File or directory already exists: $target"
            if [[ "$FORCE" == true ]]; then
                log_info "Removing existing: $target"
                rm -rf "$target"
            elif [[ "$BACKUP" == true ]]; then
                log_info "Backing up existing: $target -> ${target}.backup"
                mv "$target" "${target}.backup"
            else
                log_warning "Skipping $folder_name (use --force to overwrite or --backup to backup)"
                return 1
            fi
        fi
    fi
    
    # Create the symlink
    log_info "Creating symlink: $target -> $source"
    ln -s "$source" "$target"
    log_success "Linked $folder_name -> $target"
    return 0
}

# Main function
main() {
    echo -e "${BLUE}Linking dotfiles from $SCRIPT_DIR to $CONFIG_DIR${NC}"
    echo ""
    
    local linked_count=0
    local skipped_count=0
    local error_count=0
    
    # Find all directories in the dotfiles repo (excluding .git and this script's directory)
    while IFS= read -r -d '' folder; do
        # Get relative path from script directory
        local rel_path="${folder#$SCRIPT_DIR/}"
        local folder_name="$(basename "$rel_path")"
        
        # Skip .git directory and hidden directories starting with .
        if [[ "$folder_name" == .* ]]; then
            log_info "Skipping hidden directory: $folder_name"
            continue
        fi
        
        local source="$folder"
        local target="$CONFIG_DIR/$folder_name"
        
        if create_symlink "$source" "$target" "$folder_name"; then
            ((linked_count++))
        else
            ((skipped_count++))
        fi
    done < <(find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d -print0)
    
    echo ""
    echo -e "${GREEN}Summary:${NC}"
    echo -e "  ${GREEN}Linked:${NC}   $linked_count"
    echo -e "  ${YELLOW}Skipped:${NC}  $skipped_count"
    echo -e "  ${RED}Errors:${NC}    $error_count"
    
    if [[ $skipped_count -gt 0 ]]; then
        echo ""
        log_warning "Some folders were skipped. Use --force to overwrite or --backup to backup existing files."
    fi
}

# Run main function
main
