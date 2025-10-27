{ pkgs, ... }:

{
  programs.hyfetch = {
    enable = true;

    settings = {
      preset = "transgender";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.65;

      color_align = {
        mode = "horizontal";
        custom_colors = [];
        fore_back = null;
      };

      backend = "fastfetch";
      args = null;
      distro = null;
      pride_month_shown = [];
      pride_month_disable = false;
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = builtins.fromJSON (
      builtins.unsafeDiscardStringContext (
        builtins.readFile ../../files/fastfetch.jsonc
      )
    );
  };
  
  home.packages = with pkgs; [ pciutils ]; # Required to display GPU
}