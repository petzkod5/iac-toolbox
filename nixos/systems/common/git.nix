{ pkgs
, ...
}: {
  home-manager.users.petzko = {
    home.packages = with pkgs; [];

    programs.git = {
      enable = true;

      userName = "Dylan Petzko";
      userEmail = "petzkod@gmail.com";

      extraConfig = {
        init.defaultBranch = "main";
        url = {
          "ssh://git@github.com" = {
            insteadOf = "https://github.com";
          };
        };
      };
    };
  };
}
