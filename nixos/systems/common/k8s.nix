{ pkgs
, pkgs-stable
, ...
}: {
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    cilium-cli
    k9s
    kubectl
    kubectl-cnpg
    kubernetes-helm
    krew
    kustomize
    nodejs
    popeye
    postgresql_18
    helm
  ];
}
