{ hostName, system }:
let
  fromEnv = builtins.getEnv "DOTFILES_SECRETS";
  sudoUser = builtins.getEnv "SUDO_USER";
  homeEnv = builtins.getEnv "HOME";
  user = builtins.getEnv "USER";

  isDarwin = builtins.match ".*-darwin" system != null;

  userHome = username:
    if isDarwin then "/Users/${username}" else "/home/${username}";

  candidates =
    (if fromEnv != "" then [ "${fromEnv}/${hostName}.nix" ] else [ ])
    ++ [ "/etc/nix-secrets/${hostName}.nix" ]
    ++ (if sudoUser != "" then [ "${userHome sudoUser}/.secrets/nix/${hostName}.nix" ] else [ ])
    ++ (if homeEnv != "" && homeEnv != "/root" then [ "${homeEnv}/.secrets/nix/${hostName}.nix" ] else [ ])
    ++ (if user != "" && user != "root" then [ "${userHome user}/.secrets/nix/${hostName}.nix" ] else [ ]);

  matches = builtins.filter builtins.pathExists candidates;
  secretPath = if matches == [ ] then null else builtins.head matches;
in
if secretPath == null || secretPath == "" then
  builtins.throw ''
    Cannot locate secrets for host ${hostName}.
    Create ~/.secrets/nix/${hostName}.nix or /etc/nix-secrets/${hostName}.nix
    and run nixos-rebuild with --impure (required for the first rebuild).
  ''
else
  import secretPath
