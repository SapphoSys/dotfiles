{
  programs.gh = {
    enable = true;

    settings = {
      git_protocol = "ssh";
      aliases = {
        # explore more aliases
        cl = "repo clone";
      };
    };
  };
}