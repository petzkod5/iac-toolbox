{ config, pkgs, lib, ... }:

{
    home.username = "petzko";
    home.homeDirectory = lib.mkForce "/home/petzko";
    home.enableNixpkgsReleaseCheck = false;
    home.stateVersion = "25.05";
    
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
        go
        jq
        yq-go
        openssl
        pre-commit
        trufflehog
        wget

        # NVIM Dependencies
        ripgrep
        lazygit
        gdu
        bottom
        
        # LSP Dependencies
        stylua
        selene
        ruff
        nixd
        deadnix
        rustup
        tree-sitter
        nodejs_24
        python313
        
        # Fonts (For NVIM)
        nerd-fonts.fira-code
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
        '';
    };

    programs.zsh = {
        enable = true;

        oh-my-zsh = {
            enable = true;
            theme = "robbyrussell";
            plugins = [
                "git"
                "docker"
                "sudo"
                "command-not-found"
                "kubectl"
                "python"
                "history"
                "dirhistory"
                "colored-man-pages"
            ];
        };

        initExtra = builtins.readFile ./dotfiles/zshrc.common;
    };
}
