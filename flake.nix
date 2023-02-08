{
  description = "firehole-nixos flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
  };

  outputs = { self, nixpkgs, ... }:
  {
    # non-system suffixed items should go here
    nixosModules = {
      nixos-firehol = import ./nixos-firehol.nix ;
    }; # export single module
  };
}