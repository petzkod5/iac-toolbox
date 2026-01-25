#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

CONFIG="${1}"
if [[ -z $CONFIG ]] && [[ ! -f /etc/nix-config ]]; then
  echo -e "${RED}ERROR${NC}: No nix config was detected. Please specify system name!"
  exit 1
fi

if [[ -z $CONFIG ]]; then
  CONFIG=$(cat /etc/nix-config)
fi

echo -e "Switching NixConfig With '${GREEN}${CONFIG}${NC}'..."

sudo nixos-rebuild switch --flake ./nixos#${CONFIG}
