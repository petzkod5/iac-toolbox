{ config, pkgs, lib, ... }:

{
    home.username = "petzko";
    home.homeDirectory = lib.mkForce "/home/petzko";
    home.enableNixpkgsReleaseCheck = false;
    home.stateVersion = "25.05";

    home.packages = with pkgs; [
        go
        jq
        yq-go
        openssl
        pre-commit
        trufflehog
        wget
	    neovim
    ];

    programs.home-manager.enable = true;

    programs.neovim = {
        enable = true;
        defaultEditor = true;
        extraConfig = ''
          set et
          set sw=4
          set ts=4
          set number relativenumber
        ''
    }
}
