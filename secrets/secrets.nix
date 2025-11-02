let
  age = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJflwNs6B8GIVoGEZkeb56lqHq3qbWYp+PJZtvIGzVlZ";
  auth = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJug+9rnFngnFQpY0lAO0NuVBhDCcJc5imPHazgOSTTx";
  sign = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICM6XP+CNc2CStEDe/W4LfkcRcG98obQiM2aqnydCRbX";

  keys = [
    age
    auth
    sign
  ];
in
{
  "bluesky-pds.age".publicKeys = keys;
  "caddy.age".publicKeys = keys;
  "glance.age".publicKeys = keys;
  "lanyard.age".publicKeys = keys;
}
