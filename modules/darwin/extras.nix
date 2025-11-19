{ inputs, ... }:

{
  imports = [
    inputs.home-manager.darwinModules.home-manager
    inputs.ragenix.darwinModules.default
    inputs.darwin-login-items.darwinModules.default
  ];
}
