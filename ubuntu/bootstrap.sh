#!/usr/bin/env bash

# ==================================================
#                Rivendell Boostrap
#
# This script is intended to be run ONCE and only
# ONCE. This does the initial setup on ubuntu which
# installs all the pre-requisites before running nix
# which should handle the rest of the configuration.
#
# Tested On:
# 	Ubuntu 24.04
#
# ==================================================

CONFIGURATION="${1:-base}"

# You probably already have git since you have this repo..
# but incase you're primitive and downloaded the tarball
# this will ensure we have it
init_pkgs=(curl git)


# Initial System Upgrade and Minimal Core Pkgs
sudo apt update
sudo apt install
sudo apt install "${init_pkgs[@]}"

export PATH=/nix/var/nix/profiles/default/bin/:$PATH

# Install the Nix Pkg Manager
if ! command -v nix &>/dev/null; then
	curl -L https://nixos.org/nix/install | sh -s -- --daemon
fi


mkdir -p ~/.local/state/nix/profiles

export NIX_CONFIG="experimental-features = nix-command flakes"
if ! command -v home-manager &>/dev/null; then
	# If we don't have home manager installed yet - we have to do it this way
	nix run nixpkgs#home-manager -- switch --flake ./#$CONFIGURATION || exit 1
else
	home-manager switch --flake ./#$CONFIGURATION || exit 1
fi
