{ pkgs
, config
, lib
, ...
}: {
  programs.tmux = {
    enable = true;

    keyMode = "vi";
    prefix = "C-w";
    baseIndex = 1;
    clock24 = true;
    escapeTime = 0;
    historyLimit = 10000;
    resizeAmount = 10;
    terminal = "screen-256color";

    plugins = with pkgs.tmuxPlugins; [ resurrect yank nord ];

    extraConfig = ''
      # Automatically set window title
      set-window-option -g automatic-rename on
      set-option -g set-titles on

      # Split panes
      bind | split-window -h
      bind - split-window -v

      unbind '"'
      unbind %

      # Use Alt-vim keys without prefix key to switch panes
      bind -n M-h select-pane -L
      bind -n M-j select-pane -D
      bind -n M-k select-pane -U
      bind -n M-l select-pane -R

      # resize panes more easily
      bind < resize-pane -L 10
      bind > resize-pane -R 10

      bind-key J resize-pane -D 5
      bind-key K resize-pane -U 5
      bind-key H resize-pane -L 5
      bind-key L resize-pane -R 5

      # Shift arrow to switch windows
      bind -n S-Left  previous-window
      bind -n S-Right next-window
    '';
  };
}
