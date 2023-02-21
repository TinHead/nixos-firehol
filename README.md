# FireHOL NixOS module


### Module documentation here https://tinhead.github.io/nixos-firehol/nixos-firehol.html

## Some background

At the company I work for Essensys (https://essensys.ro), we have a fairly complicated Shorewall based firewall setup which is getting harder and harder to manage by editing configuration files.
Having a former Sysadmin converted to DevOps background and being a huge fan of NixOS, I have decided to convert the existing hardcoded infrastrucuture to NixOS where possible. 
The firewall/gateway/vpn/proxy is my next target :).
 
NixOS has it's own firewall module based on nftables(?) however it is not suitable for complex setups like our firewall. So I have settled on FireHOL and started work on this module.

## Implemented features

1. Interfaces

  Multiple interfaces are supported with the following properties:
  - name - real interface name ie eth0
  - myname - friendly name ie lan
  - src, dst - source and destination IP addresses - optional, see example below
  - policy - policy to apply - defaults to drop
  - rules - a list of rules to apply on this interface - currently a list of strings 

2. Routers 

  Multiple routes can be setup wit the properties:
  - name
  - inface - incomming traffic interface
  - outface - outgoing traffic interface
  - src,dst - source and destination IP's - optional
  - rules - a list of rules to apply on this router

## Using the module

If you don't use flakes save the module file nixos-firehol.nix and import it in your configuration.nix:

```nix
#---snip---
imports = [
   ./firehol/firhol.nix
];
#---snip---
```

With flakes add it to flake.nix:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    firehol-nixos.url = github:TinHead/nixos-firehol;
  };
  outputs = { nixpkgs, firehol-nixos, sops-nix, ... }: {
    nixosConfigurations = {
      myfw = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          firehol-nixos.nixosModules.nixos-firehol
        ];
      };
  };
}
```
And in configuration.nix add it to inputs:
```nix
{ config, pkgs, lib, firehol-nixos  , ... }:
{
#...snip...
}
```

Finally in both cases the firewall configuration would look like the example below:

```nix
#---snip---
metworking = {
  firewall.enable = false; #disable NixOS firewall 
};
services = {
      firehol = {
      enable = true;
      interfaces = {
        "eth0" = {
          myname = "internet";
          policy = "drop";
          rules =
           [
             "protection strong"
             "server icmp accept"
             "client icmp accept"
           ];
        };
        "eth1" = {
          myname = "internal";
          policy = "drop";
          src = {
            ip = "192.168.0.1";
            deny = false; #set to true to negate the rule: "interface eth1 internal src 192.168.0.1" turns into  "interface eth1 internal src not 192.168.0.1"  
          };
          rules = [
            "protection strong"
            "server ssh accept"
            "server custom unifi tcp/8443 default accept"
            "client \"dns,http,https,ldap,microsoft_ds\" accept"
            "client custom kerb tcp/88 default accept"
            "client custom rpc tcp/135 default accept"
            "client custom nbss tcp/136 default accept"
            "client custom msupp tcp/49152:65535 default accept"
            "client all reject"
          ];

        };
      };
      routers = {
          "int2inet" = {
            inface = "eth1";
            outface = "eth0";
            src = {
              ip = "192.168.0.1";
              deny = false; #set to true to negate the rule: "interface eth1 internal src 192.168.0.1" turns into  "interface eth1 internal src not 192.168.0.1"  
            };
            rules = [
              "masquerade" 
              "route all accept"
            ];
          };
        };
      };
};

#---snip---
```

### (Possible) Todos:

- rewrite the rule logic as submodule list 
- add ipset support
- add traps suuport 
- add link balancer 
- MARKs support 
