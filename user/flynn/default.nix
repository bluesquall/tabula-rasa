{ config, pkgs, ... }:

let
  USERNAME = "flynn";
  UID = 4983;
in
{
  age.secrets.hashedPassword.file = ./secrets/hashedPassword.age;

  users.users.${USERNAME} = {
    uid = UID;
    home = "/home/${USERNAME}";
    createHome = true;
    isNormalUser = true;
    extraGroups = [ "dialout" "networkmanager" "wheel" ];
    shell = pkgs.zsh; # keep a POSIX login shell
    hashedPasswordFile = config.age.secrets.hashedPassword.path;
  };

  home-manager.users.${USERNAME} = import ./home.nix;

  services.displayManager.autoLogin = {
    enable = true;
    user = USERNAME;
  };
}
