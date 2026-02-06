{ config, lib, pkgs, inputs, wrappers, ... }:

let
    user = "dylan";
    home = "/home/dylan";
    gitUser = "Dylan Petzko";
    gitEmail = "petzkod@gmail.com";
    flake-path = "${home}/iac-toolbox/ubuntu/";
in {
    
    # -----------------------------------------------------------
    # BASIC CONFIGURATION
    # -----------------------------------------------------------
    home.username = "${user}";
    home.homeDirectory = "${home}";
    home.stateVersion = "25.11"; # Don't change this - idk why I was told to
    

    # -----------------------------------------------------------
    # Environment Variables
    # -----------------------------------------------------------
    home.sessionVariables = let
    in {
        EDITOR = "nvim";
        MANPAGER = "nvim +Man!";
	    NVIM_APPNAME = "astrovim";
    };


    # -----------------------------------------------------------
    # BASIC PACKAGE INSTALLS
    # -----------------------------------------------------------
    home.packages = with pkgs; [
        nh # https://github.com/nix-community/nh Nix Utility Helper
        jq # JSON Querier
        fd # find replacer

        fzf # fuzzy searcher
        git # git yknow
        bat # cat replacer (it has color)
	    grc
        zip
        
        curl
        wget
        tldr
        gnumake
        just
        
        unzip
        
        neovim

        lazygit
        openssl
        ripgrep

        fastfetch # neofetch replacer (cause)
        man-pages

        man-pages-posix

        fish
        zsh
    ];


    # -----------------------------------------------------------
    # NIX Configuration Stuff
    # -----------------------------------------------------------
    nix = {
        package = pkgs.nix;
        settings = {
            experimental-features = [ "nix-command" "flakes" ];
        };
        gc = {
            automatic = true;
            dates = "weekly";
            options = "-d";
        };
    };


    # -----------------------------------------------------------
    # CONFIGURATION FILES
    # -----------------------------------------------------------
    xdg = {
        enable = true;
        
        configFile = {
            "starship.toml".source = ./config/starship.toml;
        };
    };


    # -----------------------------------------------------------
    # PACKAGE Configurations
    # -----------------------------------------------------------
    programs = {
        home-manager.enable = true;

        git = {
            
            enable = true;
            
            settings = {
                user = {
                    name = "${gitUser}";
                    email = "${gitEmail}";
                };
            };
        };


        fish = {
            enable = true;
            
            plugins = [
		        { name = "grc"; src = pkgs.fishPlugins.grc.src; }
		        { name = "tide"; src = pkgs.fishPlugins.tide.src; }
            ];

            shellAliases = {
                ".."    = "cd ..";
                "..."   = "cd ../..";
                "...."  = "cd ../../..";
                
                "ls" = "ls --color=auto";

                "cp"    = "cp -v";
                "mkdir" = "mkdir -pv";
                "ddf"   = "df -h";
                "rm"    = "rm -v";
                "rr"    = "rm -rf";
                "mv"    = "mv -v";

		        "vim"   = "nvim";
		        "vi"    = "nvim";

                "gfl"   = "git fetch && git pull";

                "rbh" = "rebuild-home";
                "rbh-yolo" = "rebuild-home && yologcm";
            };


            shellAbbrs = {
                g   = "git";
                gaa = "git add --all";
                gst = "git status";
                gf  = "git fetch";
                gl  = "git pull";
                gc  = "git commit";
                gcm = "git commit -m";

                lg  = "lazygit";
            };
            

            functions = {
                
                rebuild-home = ''
                function rebuild-home
                    NH_FLAKE=${flake-path} nh home build -v -t -c base && \
                    NH_FLAKE=${flake-path} nh home switch -v -t -c base && \
                    exec fish
                end
                '';

                yologcm = ''
                function yologcm
                    set msg    $(curl https://whatthecommit.com/index.txt)
                    set status $(git status)
                    git add --all
                    git commit -m $msg -m $status
                    git push
                end
                '';
            };
        };

        
        # starship = {
        #     enable = true;
        #
        #     enableFishIntegration = true;
        # };
    };

    imports = [
    ];
}
