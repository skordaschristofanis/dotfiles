{ hostName }:
let
  fromEnv = builtins.getEnv "DOTFILES_SECRETS";
  sudoUser = builtins.getEnv "SUDO_USER";
  homeEnv = builtins.getEnv "HOME";
  user = builtins.getEnv "USER";

  home =
    if homeEnv != "" then homeEnv
    else if sudoUser != "" then "/home/${sudoUser}"
    else if user != "" && user != "root" then
      if hostName == "vortex" then "/Users/${user}" else "/home/${user}"
    else null;

  secretPath =
    if fromEnv != "" then "${fromEnv}/${hostName}.nix"
    else if home != null then "${home}/.secrets/nix/${hostName}.nix"
    else null;
in
if secretPath == null then
  builtins.throw ''
    Cannot locate secrets for host ${hostName}.
    Set HOME or run via sudo as a normal user, or set DOTFILES_SECRETS.
  ''
else if builtins.pathExists secretPath
then import secretPath
else builtins.throw ''
  Missing secrets file: ${secretPath}
  Copy secrets/${hostName}.nix.example to that path and fill in your values.
''
