{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
  };

  # Link zsh completions
  environment.pathsToLink = [ "/share/zsh" ];
}
