{ pkgs, ...}:
let
  src =  ../.;
  pkg = pkgs.writeText "nixos-firehol.nix"
    (builtins.replaceStrings
      ["lib.mdDoc "]
      [""]
      (builtins.readFile "${src}/nixos-firehol.nix"));
in
{
  files.docs."/gh-pages/nixos-firehol.md".modules = [
    "${pkg}"
  ];
  files.mdbook.summary = ''
    ---
    - [NixOS-FireHOL](./nixos-firehol.md)
  '';
}
