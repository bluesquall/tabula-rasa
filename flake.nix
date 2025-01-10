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

  outputs = { self, nixpkgs, home-manager, sops-nix, ... }@inputs : {

    homeConfigurations = {
      flynn = home-manager.lib.homeManagerConfiguration {
        # pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          ./user/flynn/home.nix
          sops-nix.nixosModules.sops
        ];
        # extraSpecialArgs = { inherit inputs outputs; };
      };
    };

    nixosConfigurations = {

      iso = nixpkgs.lib.nixosSystem {
        # inherit pkgs;
        system = "x86_64-linux";
        modules = [
          ./base.nix
          sops-nix.nixosModules.sops
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
      };

      encom = nixpkgs.lib.nixosSystem {
        # inherit pkgs;
        system = "x86_64-linux";
        modules = [
          sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            # ^otherwise pure evaluation fails for flakes
            home-manager.useUserPackages = true;
          }
          ./base.nix
          ./os/encom
          ./user/flynn
        ];
      };
    };
  };
}
