#!/usr/bin/env bash

CONFIG="${1:?Provide system config name}"

sudo nixos-rebuild switch --flake ./nixos#${CONFIG}
