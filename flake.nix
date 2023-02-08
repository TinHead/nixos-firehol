{
  description = "firehole-nixos flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-22.11";
  };

  outputs = { self, nixpkgs, ... }:
  {
    # non-system suffixed items should go here
    nixosModule = import ./nixos-firehol.nix; # export single module
  };
}