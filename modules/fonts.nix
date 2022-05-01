
{
  fonts = {
    fonts = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" "Noto" "Mononoki" "JetBrainsMono" "Iosevka" "RobotoMono" ]; })
      noto-fonts
      noto-fonts-emoji
      fira-code
    ];

    fontconfig.defaultFonts = {
      serif = [ "Noto Serif" "Noto Serif Nerd Font" ];
      sansSerif = [ "NotoSans Nerd Font" "Noto Sans" ];
      monospace = [ "Fira Code Nerd Font" "Fira Code Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };
}