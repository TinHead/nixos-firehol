{
  description = "firehole-nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    dsf.url = "github:cruel-intentions/devshell-files";
    gha.url = "github:cruel-intentions/gh-actions";
  };

  outputs = {
    self,
    nixpkgs,
    dsf,
    ...
  }: 
let pkgs = nixpkgs.legacyPackages.x86_64-linux;
in  
  {
    # non-system suffixed items should go here
    nixosModules = {
      nixos-firehol = import ./nixos-firehol.nix;
    };
    nixosModule = self.nixosModules.nixos-firehol; # export single module
  };
}
