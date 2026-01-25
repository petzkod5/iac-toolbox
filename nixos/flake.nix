{
    description = "NixOS Configurations";

    inputs = {
        nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
        nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-25.05";
        nixos-wsl.url = "github:nix-community/NixOS-WSL";
        nix-ld.url = "github:Mic92/nix-ld";
        home-manager = {
            url = "github:nix-community/home-manager/release-25.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };

    outputs = inputs@{ self, nixpkgs, nixpkgs-stable, nixos-wsl, nix-ld, home-manager, ... }: {

        nixosConfigurations = {
        isengard = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
                
            modules = [
                
                ({ config, pkgs, ...}: {
                    networking.hostName = "isengard";
                    system.stateVersion = "25.05";
                })


                ({ config, pkgs, ... }: {
                    users.users.petzko = {
                        isNormalUser = true;
                        home = "/home/petzko";
                        extraGroups = [ "wheel" ];
                        hashedPassword = "";
                        #shell = pkgs.zsh;

                    };
                })

                nix-ld.nixosModules.nix-ld
                { programs.nix-ld.dev.enable = true; }

                ./systems/common

                home-manager.nixosModules.home-manager
                {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.users.petzko = import ./nix/systems/common/home-manager.nix;
                }


                ({ pkgs, ... }: {
                    nix.settings.experimental-features = [ "nix-command" "flakes" ];

                    nix.settings.download-buffer-size = 2000000000;

                    nix.gc = { automatic = true; dates = "weekly"; options = "--delete-older-than 1w"; };

                    nixpkgs.config.allowUnfree = true;

                    environment.systemPackages = [
                        pkgs.age
                        pkgs.git
                    ];
                })

                # WSL Support Here
                nixos-wsl.nixosModules.default
                ({ pkgs, ... }: {
                    wsl.enable = true;
                    wsl.defaultUser = "petzko";
                    environment.systemPackages = with pkgs; [ wslu ];
                })
                
            ];
        };
        };

    }; 
}
