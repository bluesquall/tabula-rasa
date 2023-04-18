# flake.nix
{
  description = "blank slate";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix.url = "github:yaxitech/ragenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, agenix, home-manager, ... }:
  let

    lib = nixpkgs.lib;
    system = "x86_64-linux";
    overlays = [ agenix.overlay ];

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    baseModules = [
      agenix.nixosModules.age
      ({ lib, pkgs, ... }: {
        nix = {
          package = pkgs.nixUnstable;
          extraOptions = "experimental-features = nix-command flakes recursive-nix";
          systemFeatures = [ "recursive-nix" ];
        };

        networking = {
          networkmanager.enable = true;
          wireless.enable = lib.mkForce false;
          # ^because WPA Supplicant cannot run with NetworkManager
        };

        environment.systemPackages = with pkgs; [
          agenix.defaultPackage.x86_64-linux
          bash curl git neovim tmux zsh
        ];
      })
    ];

  in {

    homeConfigurations = {
      flynn = home-manager.lib.homeManagerConfiguration {
        # TODO^ Is there and idomatic way to put this in ./user/flynn/flake.nix?
	pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./user/flynn/home.nix ];
	# extraSpecialArgs = { inherit inputs outputs; };
      };
    };

    nixosConfigurations = {

      iso = lib.nixosSystem {
        inherit pkgs system;
        modules = baseModules ++ [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };

      encom = lib.nixosSystem {
        inherit pkgs system;
        modules = baseModules ++ [
	  home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
	    # ^otherwise pure evaluation fails for flakes
	    home-manager.useUserPackages = true;
          }
          ./os/encom
          ./user/flynn
        ];
      };
    };
  };
}
