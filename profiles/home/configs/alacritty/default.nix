{ pkgs 
, config
, lib
, ... }:
let
  keybind = key: mods: action: { inherit key mods action; };
  viKeybind = key: mods: action: {
    inherit key mods action;
    mode = "Vi";
  };
  palette = (import ../../../../palettes);
in
{
  programs.alacritty = {
    enable = true;
    package = pkgs.alacritty;
    settings = {
      colors = {
        inherit (palette) normal bright;

        primary = {
          foreground = palette.primary.foreground or palette.normal.white;
          background = palette.primary.background or palette.normal.black;
        };

        cursor = {
          text = palette.cursor.text or palette.bright.black;
          cursor = palette.cursor.cursor or palette.normal.white;
        };

        selection = {
          text = palette.selection.text or palette.normal.white;
          background = palette.selection.background or palette.bright.black;
        };
      };

      env.TERM = "xterm-256color";

      font = {
        size = 9;
        normal.family = "FiraCode Nerd Font";
        bold = {
          family = "monospace";
          style = "Bold";
        };
        italic = {
          family = "monospace";
          style = "Italic";
        };
      };

      window.opacity = 1;
      cursor.style = "Block";
      cursor.vi_mode_style = "Block";

      live_config_reload = true;

      shell.program = "${pkgs.zsh}/bin/zsh";

      key_bindings = [
        (keybind "V" "Alt" "Paste")
        (keybind "C" "Alt" "Copy")

        (keybind "Key0" "Control" "ResetFontSize")

        (keybind "Equals" "Control" "IncreaseFontSize")
        (keybind "Plus" "Control" "IncreaseFontSize")
        (keybind "Minus" "Control" "DecreaseFontSize")

        # Vi Mode
        (viKeybind "V" "Shift|Alt" "ScrollToBottom")
        (keybind "V" "Shift|Alt" "ToggleViMode")
      ];
   };
 };
}