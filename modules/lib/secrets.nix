{ hostName, system }:
let
  fromEnv = builtins.getEnv "DOTFILES_SECRETS";
  sudoUser = builtins.getEnv "SUDO_USER";
  homeEnv = builtins.getEnv "HOME";
  user = builtins.getEnv "USER";

  isDarwin = builtins.match ".*-darwin" system != null;

  userHome = username:
    if isDarwin then "/Users/${username}" else "/home/${username}";

  home =
    if sudoUser != "" then userHome sudoUser
    else if homeEnv != "" && homeEnv != "/root" then homeEnv
    else if user != "" && user != "root" then userHome user
    else null;

  secretPath =
    if fromEnv != "" then "${fromEnv}/${hostName}.nix"
    else if home != null then "${home}/.secrets/nix/${hostName}.nix"
    else null;
in
if secretPath == null then
  builtins.throw ''
    Cannot locate secrets for host ${hostName}.
    Run with --impure, set DOTFILES_SECRETS, or run via sudo as a normal user.
  ''
else if builtins.pathExists secretPath
then import secretPath
else builtins.throw ''
  Missing secrets file: ${secretPath}
  Copy secrets/${hostName}.nix.example to that path and fill in your values.
''
