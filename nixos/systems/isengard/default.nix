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
      "--cluster-cidr=10.42.0.0/16"
      "--service-cidr=10.43.0.0/16"
    ];
  };
  
  networking.firewall.enable = false;
  networking.firewall = {
    allowedTCPPorts = [
      6443
      10250
      15021  # Istio health checks
      80     # Istio Gateway
      443    # Istio Gateway
      15012  # Istio control plane
      15017  # Istio webhook
      30080
      30443
    ];
    allowedUDPPorts = [
      8472
    ];
  };

  home-manager.users.petzko = {
    programs.zsh.initContent = builtins.readFile ./dotfiles/zshrc;
  };

  environment.systemPackages = with pkgs; [
    istioctl

  ];
}
