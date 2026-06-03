{ config, lib, pkgs, ... }:

let
  cfg = config.services.hplip-printer-app;
  optsString = lib.concatStringsSep " " (
    lib.mapAttrsToList (k: v: "-o ${lib.escapeShellArg k}=${lib.escapeShellArg v}") cfg.serverOptions
  );
in {
  options.services.hplip-printer-app = {
    enable = lib.mkEnableOption "HPLIP Printer Application";

    package = lib.mkOption {
      type = lib.types.package;
      description = "The hplip-printer-app package to use.";
    };

    serverOptions = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = { "server-port" = "8000"; "listen-hostname" = "localhost"; };
      description = "Server options passed to hplip-printer-app via -o.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the configured port.";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ (lib.toInt (cfg.serverOptions."server-port" or "8000")) ];
    networking.firewall.allowedUDPPorts = lib.mkIf cfg.openFirewall [ (lib.toInt (cfg.serverOptions."server-port" or "8000")) ];

    systemd.services.hplip-printer-app = {
      description = "HPLIP Printer Application";
      after = [ "network.target" "avahi-daemon.service" ];
      wants = [ "avahi-daemon.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/hplip-printer-app ${optsString} server";
        ExecStop = "${cfg.package}/bin/hplip-printer-app shutdown";
        Type = "simple";
        Restart = "on-failure";
        # Running as root is required for proprietary plugin installation and USB access
      };
    };
  };
}