{ pkgs
, ...
}: {
  users.users.petzko.extraGroups = [ "docker" ];

  virtualisation.docker = {
    enable = true;
    extraPackages = with pkgs; [
      docker-buildx
    ];
  };

}
