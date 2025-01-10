# flake.nix
{
  description = "blank slate";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs :

  let
    baseModules = [
      nix = {
        # package = pkgs.nixVersions.stable;
        settings.experimental-features = [ "nix-command" "flakes" "recursive-nix" ];
      }

      networking = {
        networkmanager.enable = true;
        wireless.enable = nixpkgs.lib.mkForce false;
        # ^because WPA Supplicant cannot run with NetworkManager
      };

      environment.systemPackages = with pkgs; [
        age bash curl git neovim tmux zsh
      ];

      sops-nix.nixosModules.sops
    ];

  in {

    homeConfigurations = {
      flynn = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./user/flynn/home.nix ];
        # extraSpecialArgs = { inherit inputs outputs; };
      };
    };

    nixosConfigurations = {

      iso = nixpkgs.lib.nixosSystem {
        # inherit pkgs;
        system = "x86_64-linux";
        modules = baseModules ++ [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };

      encom = nixpkgs.lib.nixosSystem {
        # inherit pkgs;
        system = "x86_64-linux";
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
