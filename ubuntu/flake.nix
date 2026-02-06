{
	description = "Rivendell Ubuntu";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { nixpkgs, home-manager, ... }:
		let
			system = "x86_64-linux";
			user = builtins.getEnv "USER";
			pkgs = nixpkgs.legacyPackages.${system};
		in {
			homeConfigurations = {
				"base" = home-manager.lib.homeManagerConfiguration {
					inherit pkgs;
					modules = [
						./home-manager/home.nix
					];
				};
			};
		};
			
}
