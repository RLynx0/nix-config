{ ... }:

{
  programs.git = {
    enable = true;
    aliases = {
      lg = "lg1";
      lgs = "lg-specific";
      lg-specific = "lg1-specific";

      lg1 = "lg1-specific --all";
      lg2 = "lg2-specific --all";
      lg3 = "lg3-specific --all";
      lg1s = "lg1-specific";
      lg2s = "lg2-specific";
      lg3s = "lg3-specific";

      lg1-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)'";
      lg2-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(auto)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)'";
      lg3-specific = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset) %C(bold cyan)(comitted: %cD)%C(reset) %C(auto)%d%C(reset)%n''           %C(white)%s%C(reset)%n''           %C(dim white)- %an <%ae> %C(reset) %C(dim white)(committer: %cn <%ce>)%C(reset)'";

      staash = "stash --all";
      forget = "!git add . && git stash && git stash clear";
    };
  };
}
