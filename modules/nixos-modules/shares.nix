{ config, lib, pkgs, secrets, ... }:
let
  cfg = config.modules.shares;
in
{
  options.modules.shares = {
    enable = lib.mkEnableOption "autofs CIFS/NFS shares from secrets" // {
      default = false;
    };
  };

  config = lib.mkIf cfg.enable (
    let
      user = secrets.username;
      smb = secrets.smb or { };
      mounts = smb.mounts or { };

      uid = toString (
        smb.uid or (
          if config.users.users.${user}.uid != null
          then config.users.users.${user}.uid
          else 1000
        )
      );
      # users.*.gid does not exist; resolve via the user's primary group name.
      primaryGroup = config.users.users.${user}.group;
      gid = toString (
        smb.gid or (
          if config.users.groups ? ${primaryGroup}
            && config.users.groups.${primaryGroup}.gid != null
          then config.users.groups.${primaryGroup}.gid
          else 1000
        )
      );
      # CIFS does not expand ~; normalize to an absolute path under the user home.
      homeDir = config.users.users.${user}.home;
      credsRaw = smb.credentialsFile or "";
      creds =
        if lib.hasPrefix "~/" credsRaw then
          homeDir + lib.removePrefix "~" credsRaw
        else if credsRaw == "~" then
          homeDir
        else
          credsRaw;

      defaultCifs =
        "fstype=cifs,rw,soft,mfsymlinks,vers=3.0,credentials=${creds},uid=${uid},gid=${gid},file_mode=0755,dir_mode=0755,sec=ntlmssp";
      defaultNfs = "fstype=nfs,rw,nosuid,nodev,nolock,soft,vers=3";

      entryLine = name: entry:
        let
          fstype = entry.fstype or "cifs";
          opts =
            entry.options or (
              if fstype == "nfs" then defaultNfs else defaultCifs
            );
          # autofs requires ://host/share for CIFS (leading colon).
          rawDevice = entry.device;
          device =
            if fstype == "cifs" && lib.hasPrefix "//" rawDevice then
              ":" + rawDevice
            else
              rawDevice;
        in
        "${name} -${opts} ${device}";

      mapFile = mountName: entries:
        pkgs.writeText "${mountName}.mount" (
          lib.concatStringsSep "\n" (
            lib.mapAttrsToList entryLine entries
          )
          + "\n"
        );

      mapFiles = lib.mapAttrs mapFile mounts;

      autoMaster = lib.concatStringsSep "\n" (
        lib.mapAttrsToList (mountName: file: "/${mountName} file:${file} --ghost") mapFiles
      );

      touchPaths = lib.flatten (
        lib.mapAttrsToList (
          mountName: entries:
          lib.mapAttrsToList (key: _: "/${mountName}/${key}") entries
        ) mounts
      );
    in
    {
      assertions = [
        {
          assertion = creds != "";
          message = ''
            modules.shares requires secrets.smb.credentialsFile
            (path to a credentials file with domain=/username=/password=; do not put the password in Nix).
          '';
        }
        {
          assertion = mounts != { };
          message = "modules.shares requires secrets.smb.mounts (attrset of autofs maps).";
        }
      ];

      environment.systemPackages = with pkgs; [
        cifs-utils
        nfs-utils
      ];

      boot.supportedFilesystems = {
        cifs = true;
        nfs = true;
      };

      # Ensure the cifs module is available without relying on on-demand load.
      boot.kernelModules = [ "cifs" ];

      services.autofs = {
        enable = true;
        inherit autoMaster;
      };

      # NixOS gives autofs a minimal PATH that does not include mount.cifs/mount.nfs.
      systemd.services.autofs.path = [
        pkgs.cifs-utils
        pkgs.nfs-utils
        pkgs.util-linux
        pkgs.coreutils
      ];

      systemd.timers.touch-autofs-shares = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnBootSec = "1min";
          OnUnitActiveSec = "5min";
          AccuracySec = "1min";
        };
      };

      systemd.services.touch-autofs-shares = {
        description = "Touch autofs mount points so shares stay mounted";
        after = [ "autofs.service" "network-online.target" ];
        wants = [ "network-online.target" ];
        serviceConfig.Type = "oneshot";
        script = lib.concatMapStringsSep "\n" (d: ''
          cd "${d}" >/dev/null 2>&1 || true
        '') touchPaths;
      };
    }
  );
}
