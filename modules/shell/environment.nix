{
  flake.modules.homeManager.shell =
    { config, lib, ... }:
    let
      inherit (config.xdg)
        configHome
        cacheHome
        dataHome
        stateHome
        ;
      home = config.home.homeDirectory;
    in
    {
      xdg.enable = true;

      home.sessionVariables = {
        CALCHISTFILE = "${cacheHome}/calc_history";
        CARGO_HOME = "${configHome}/cargo";
        DOCKER_CONFIG = "${configHome}/docker";
        DOTNET_CLI_HOME = "${dataHome}/dotnet";
        GHCUP_USE_XDG_DIRS = "true";
        GNUPGHOME = "${configHome}/gnupg";
        GOPATH = "${home}/Personal/Programming/go";
        GRADLE_USER_HOME = "${dataHome}/gradle";
        # Preserve the existing GTK2 configuration instead of Stylix's default path.
        GTK2_RC_FILES = lib.mkForce "${configHome}/gtk-2.0/gtkrc-2.0";
        HISTFILE = "${stateHome}/bash/history";
        LESSHISTFILE = "${configHome}/less/history";
        LESSKEY = "${configHome}/less/keys";
        NODE_REPL_HISTORY = "${dataHome}/node_repl_history";
        NPM_CONFIG_CACHE = "${cacheHome}/npm";
        NPM_CONFIG_PREFIX = "${configHome}/npm";
        NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
        NUGET_PACKAGES = "${cacheHome}/NuGetPackages";
        PARALLEL_HOME = "${configHome}/parallel";
        PYTHONPYCACHEPREFIX = "${cacheHome}/python";
        PYTHONUSERBASE = "${dataHome}/python";
        PYTHON_HISTORY = "${stateHome}/python/history";
        RANDFILE = "${dataHome}/randfile";
        SCREENRC = "${configHome}/screen/screenrc";
        SCREENDIR = "$XDG_RUNTIME_DIR/screen";
        STACK_XDG = "1";
        W3M_DIR = "${dataHome}/w3m";
        WGETRC = "${configHome}/wgetrc";
        WINEPREFIX = "${dataHome}/wine";

        QT_IM_MODULE = "fcitx5";
        SDL_IM_MODULE = "fcitx5";
        XMODIFIERS = "@im=fcitx5";
      };

      home.sessionPath = [
        "${home}/.local/bin"
        "${configHome}/cargo/bin"
        "${configHome}/cabal/bin"
      ];

      home.shellAliases = {
        svn = "svn --config-dir ${configHome}/subversion";
        wget = "wget --hsts-file='${dataHome}/wget-hsts'";
      };
    };
}
