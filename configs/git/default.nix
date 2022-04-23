{}: {
  userName = "7h3730b";
  userEmail = "teo.sb@protonmail.com";

  aliases = {
    st = "status";
    co = "checkout";
    df = "diff";
    lg = "log --oneline";
    p = "push";
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
}