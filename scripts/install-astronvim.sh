#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default values
VERSION="latest"
REMOVE=false

# Paths
NVIM_CONFIG="$HOME/.config/astrovim"
NVIM_DATA="$HOME/.local/share/astrovim"
NVIM_STATE="$HOME/.local/state/astrovim"
NVIM_CACHE="$HOME/.cache/astrovim"

# Backup paths
BACKUP_SUFFIX=".bak.$(date +%Y%m%d_%H%M%S)"

print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --version VERSION    Install specific AstroVim version (default: latest)"
    echo "  --remove             Remove AstroVim installation"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                   # Install latest version"
    echo "  $0 --version v4.0.0  # Install specific version"
    echo "  $0 --remove          # Uninstall AstroVim"
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    local missing_deps=()
    
    for cmd in git nvim; do
        if ! command -v "$cmd" &> /dev/null; then
            missing_deps+=("$cmd")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Missing required dependencies: ${missing_deps[*]}"
        exit 1
    fi
}

backup_existing() {
    local path=$1
    local backup_path="${path}${BACKUP_SUFFIX}"
    
    if [ -e "$path" ]; then
        log_info "Backing up $path to $backup_path"
        mv "$path" "$backup_path"
    fi
}

remove_astrovim() {
    log_info "Removing AstroVim installation..."
    
    if [ ! -d "$NVIM_CONFIG" ]; then
        log_warn "AstroVim not found at $NVIM_CONFIG"
        return
    fi
    
    # Check if it's actually AstroVim
    if [ ! -f "$NVIM_CONFIG/init.lua" ]; then
        log_error "Directory exists but doesn't appear to be AstroVim. Aborting."
        exit 1
    fi
    
    echo "This will remove:"
    echo "  - $NVIM_CONFIG"
    echo "  - $NVIM_DATA"
    echo "  - $NVIM_STATE"
    echo "  - $NVIM_CACHE"
    echo ""
    read -p "Are you sure you want to continue? (y/N) " -n 1 -r
    echo
    
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Removal cancelled"
        exit 0
    fi
    
    # Backup before removing
    backup_existing "$NVIM_CONFIG"
    backup_existing "$NVIM_DATA"
    backup_existing "$NVIM_STATE"
    backup_existing "$NVIM_CACHE"
    
    log_info "AstroVim removed successfully. Backups created with suffix: $BACKUP_SUFFIX"
}

install_astrovim() {
    log_info "Starting AstroVim installation (version: $VERSION)..."
    
    # Check if already installed
    if [ -d "$NVIM_CONFIG" ]; then
        log_warn "Neovim configuration already exists at $NVIM_CONFIG"
        log_warn "Skipping installation to prevent overwriting existing config."
        log_warn "Use --remove to uninstall first, or manually backup/remove the directory."
        exit 1
    fi
    
    # Backup existing neovim data (optional but recommended)
    backup_existing "$NVIM_DATA"
    backup_existing "$NVIM_STATE"
    backup_existing "$NVIM_CACHE"
    
    # Clone AstroVim template
    log_info "Cloning AstroVim template..."
    
    if [ "$VERSION" = "latest" ]; then
        git clone --depth 1 https://github.com/AstroNvim/template "$NVIM_CONFIG"
    else
        git clone --depth 1 --branch "$VERSION" https://github.com/AstroNvim/template "$NVIM_CONFIG"
    fi
    
    # Remove git connection
    log_info "Removing template's git connection..."
    rm -rf "$NVIM_CONFIG/.git"
    
    log_info "AstroVim installed successfully!"
    echo ""
    log_info "Next steps:"
    echo "  1. Set NVIM_APPNAME environment variable:"
    echo "     export NVIM_APPNAME=astrovim"
    echo "  2. Run 'nvim' to start Neovim with AstroVim"
    echo "  3. AstroVim will automatically install plugins on first launch"
    echo "  4. Install LSP servers with :LspInstall <server>"
    echo "  5. Install language parsers with :TSInstall <language>"
    echo "  6. Install debuggers with :DapInstall <debugger>"
    echo ""
    log_info "To make NVIM_APPNAME permanent, add to your shell config:"
    echo "  For Bash: echo 'export NVIM_APPNAME=astrovim' >> ~/.bashrc"
    echo "  For Zsh:  echo 'export NVIM_APPNAME=astrovim' >> ~/.zshrc"
    echo "  Or configure it in your NixOS/home-manager configuration"
    echo ""
    log_info "To set up your own git repository for this config:"
    echo "  cd $NVIM_CONFIG"
    echo "  git init"
    echo "  git add ."
    echo "  git commit -m 'Initial AstroVim configuration'"
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2
            ;;
        --remove)
            REMOVE=true
            shift
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            print_usage
            exit 1
            ;;
    esac
done

# Main execution
check_dependencies

if [ "$REMOVE" = true ]; then
    remove_astrovim
else
    install_astrovim
fi
