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
    ];

    programs.home-manager.enable = true;
}
