{ config, hostType, lib, sworkstyle, nix-vscode-extensions, extraRoles, ... }:
if hostType == "nixos" || hostType == "darwin" then {
  imports = [
    (
      if hostType == "nixos" then ./nixos.nix
      else if hostType == "darwin" then ./darwin.nix
      else throw "No sysConfig for hostType '${hostType}'"
    )
  ];
  home-manager.users.ogge = {
    imports = [
      ./core
      ./modules
    ];
    home.username = config.users.users.ogge.name;
    home.uid = config.users.users.ogge.uid;
    home.sessionPath = [
      "$HOME/.cargo/bin"
      "$HOME/.local/bin"
    ];
  };
}
else if hostType == "homeManager" then {
  imports = [
    ./core
    ./modules
  ];
  programs.home-manager.enable = true;
} else throw "Unknown hostType '${hostType}'"
