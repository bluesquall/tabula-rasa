let
  flynn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQ6tWsF5rxxYMnfa1fBSAB5NCTpPSfsvyarRFUGpTwU";

  encom = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKzqvmMHoKedc6xW6cUwAeSaIy5+JXpKJxOR4AjqD7Fy";
  systems = [ encom ];
in
{
  "hashedPassword.age".publicKeys = [ flynn ] ++ systems;
}
