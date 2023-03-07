{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.firehol;
  fireholInterfaces = list:
    builtins.listToAttrs (lib.forEach list (intf: {
      name = intf.name;
      value = intf;
    }));
  fireholInterface = {
    name,
    config,
    ...
  }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
        description = "Interface name";
      };
      myname = mkOption {
        type = types.str;
        default = "lan";
        description = "Interface custom name for readability";
      };
      src = mkOption {
        default = {};
        description = "Source IP address";
        type = with types;
          submodule {
            options = {
              ip = mkOption {
                description = "IP address";
                type = str;
                default = "";
              };
              deny = mkOption {
                description = "Set to true to negate IP (add not in front)";
                type = bool;
                default = false;
              };
            };
          };
      };
      dst = mkOption {
        default = {};
        description = "Destination IP address";
        type = with types;
          submodule {
            options = {
              ip = mkOption {
                description = "IP address";
                type = str;
                default = "";
              };
              deny = mkOption {
                description = "Set to true to negate IP (add not in front)";
                type = bool;
                default = false;
              };
            };
          };
      };
      policy = mkOption {
        type = types.enum ["accept" "reject" "drop"];
        default = "drop";
        description = "Default policy on this interface";
      };
      rules = mkOption {
        type = types.listOf types.str;
        default = ["client all accept"];
      };
    };
  };
  fireholRouters = list:
    builtins.listToAttrs (lib.forEach list (router: {
      name = router.name;
      value = router;
    }));
  fireholRouter = {
    name,
    config,
    ...
  }: {
    options = {
      name = mkOption {
        type = types.str;
        default = name;
        description = "Router name";
      };
      inface = mkOption {
        type = types.str;
        default = "lan";
        description = "Input interface";
      };
      outface = mkOption {
        type = types.str;
        default = "";
        description = "Output interface";
      };
      src = mkOption {
        description = "Source IP address";
        default = {};
        type = with types;
          submodule {
            options = {
              ip = mkOption {
                description = "IP address";
                type = str;
                default = "";
              };
              deny = mkOption {
                description = "Set to true to negate IP (add not in front)";
                type = bool;
                default = false;
              };
            };
          };
      };
      dst = mkOption {
        default = {};
        type = with types;
          submodule {
            options = {
              ip = mkOption {
                description = "IP address";
                type = str;
                default = "";
              };
              deny = mkOption {
                description = "Set to true to negate IP (add not in front)";
                type = bool;
                default = false;
              };
            };
          };
      };
      # list of rules to apply -- could not find a better way to implement
      rules = mkOption {
        description = "List of router rules to apply";
        type = types.listOf types.str;
        default = ["router all accept"];
      };
    };
  };
  #generate the configuration
  confFile = ''
    ${concatMapStrings ({
      name,
      myname,
      src,
      dst,
      policy,
      rules,
    }: ''
      interface4 ${name} ${myname} ${
        (
          if (src.ip != "")
          then
            (
              if src.deny == true
              then ''src not ${src.ip}''
              else ''src ${src.ip}''
            )
          else ''''
        )
      }
          ${
        if (dst.ip != "")
        then
          (
            if dst.deny == true
            then ''dst not ${dst.ip}''
            else ''dst ${dst.ip}''
          )
        else ''''
      }
          policy ${policy}
          ${concatStringsSep "\n    " rules}
    '') (attrValues cfg.interfaces)}
    ${concatMapStrings ({
      name,
      inface,
      outface,
      src,
      dst,
      rules,
    }: ''
      router4 ${name} inface ${inface} outface ${outface} ${
        (
          if (src.ip != "")
          then
            (
              if src.deny == true
              then ''src not ${src.ip}''
              else ''src ${src.ip}''
            )
          else ''''
        )
      }
          ${
        if (dst.ip != "")
        then
          (
            if dst.deny == true
            then ''dst not ${dst.ip}''
            else ''dst ${dst.ip}''
          )
        else ''''
      }
          ${concatStringsSep "\n    " rules}
    '') (attrValues cfg.routers)}
  '';
in {
  #implementation
  options = {
    services.firehol = {
      enable = mkEnableOption (lib.mdDoc "Firehol firewall for humans!");
      interfaces = mkOption {
        default = {};
        type = with types; coercedTo (listOf attrs) fireholInterfaces (attrsOf (types.submodule fireholInterface));
        description = lib.mdDoc ''List of interfaces to use '';
        example = {
          "eth1" = {
            myname = "lan";
          };
        };
      };
      routers = mkOption {
        default = {};
        type = with types; coercedTo (listOf attrs) fireholRouters (attrsOf (types.submodule fireholRouter));
        description = lib.mdDoc ''List of Routers to create '';
        example = {
          "lan2wan" = {
          };
        };
      };
    };
  };
  # systemd service
  config = mkIf cfg.enable {
    environment.etc."firehol/firehol.conf".text = confFile;
    systemd.services.firehol = {
      description = "FireHol a firewall for humans";
      after = ["systemd-modules-load.service" "local-fs.target"];
      wants = ["network-pre.target" "systemd-modules-load.service" "local-fs.target"];
      before = ["shutdown.target"];
      conflicts = ["shutdown.target"];
      restartIfChanged = true;
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = "${pkgs.firehol}/bin/firehol start";
        ExecStop = "${pkgs.firehol}/bin/fireqos stop";
        ExecReload = "${pkgs.firehol}/bin/firehol start";
      };
    };
  };
}
