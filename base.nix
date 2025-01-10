{ config, lib, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" "recursive-nix" ];

  networking = {
    networkmanager.enable = true;
    wireless.enable = lib.mkForce false;
    # ^because WPA Supplicant cannot run with NetworkManager
  };

  environment.systemPackages = with pkgs; [
    age bash curl git neovim tmux zsh
  ];
}
