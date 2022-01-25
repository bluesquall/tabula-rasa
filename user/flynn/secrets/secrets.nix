let
  flynn = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINQ6tWsF5rxxYMnfa1fBSAB5NCTpPSfsvyarRFUGpTwU";

  encom = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOLYEOcd1afO/HzRNoxYFQQlDYCTesQhtt01DyMq9l32";
  systems = [ encom ];
in
{
  "hashedPassword.age".publicKeys = [ flynn ] ++ systems;
}
