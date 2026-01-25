{ config, pkgs, hostname, lib, ... }:

{

    # Create a nix-config file in /etc/ that says the name of the hostname used
    environment.etc."nix-config".text = hostname;

    environment.systemPackages = with pkgs; [
        vim
        git
        just
        unzip
        fd
        ripgrep

        # Custom Scripts
        (pkgs.writeScriptBin "nixos-rebuild-switch" (builtins.readFile ../../../scripts/nixos-switch.sh))
    ];

    imports = [
        ./docker.nix
        ./git.nix
        ./k8s.nix
    ];

}
