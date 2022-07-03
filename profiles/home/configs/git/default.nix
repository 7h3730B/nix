{ pkgs
, config
, lib
, ...
}: with lib; {
  programs.git = {
    enable = true;
    userName = mkDefault "7h3730b";
    userEmail = mkDefault "56200898+7h3730B@users.noreply.github.com";

    aliases = {
      st = "status -s";
      co = "checkout";
      df = "diff";
      lg = "log --oneline";
      p = "push";
      pf = "push --force-with-lease";
      c = "commmit";
      a = "add";
    };

    lfs.enable = true;

    extraConfig = {
      init.defaultBranch = "master";
      pull.rebase = true;

      pager = {
        diff = "delta";
        log = "delta";
        reflog = "delta";
        show = "delta";
      };
    };
  };
}
