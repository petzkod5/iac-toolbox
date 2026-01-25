{ config
, pkgs
, ...
}: {
  services.k3s = {
    enable = true;
    role = "server";
    extraFlags = toString [
      "--disable=traefik"
      "--write-kubeconfig-mode=644"
      "--tls-san=${config.networking.hostName}"
    ];
  };

  networking.firewall = {
    allowedTCPPorts = [
      6443
      10250
    ];
    allowedUDPPorts = [
      8472
    ];
  };

  home-manager.users.petzko = {
    programs.zsh.initContent = builtins.readFile ./dotfiles/zshrc;
  };
}
