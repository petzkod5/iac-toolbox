{ config, pkgs, ... };

{
    environment.systemPackages = with pkgs; [
        vim
        git
        just
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

}
