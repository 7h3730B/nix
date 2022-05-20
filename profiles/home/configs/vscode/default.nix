{ pkgs
, config
, lib
, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # dracula theme
      dracula-theme.theme-dracula
      # nix support
      bbenoist.nix
      # vim emulation
      vscodevim.vim
      # bracket pair colorizer
      coenraads.bracket-pair-colorizer-2
      # apk reversing
      # surendrajat.apklab
      # Smali support
      # loyieking.smalise
      # toml support
      bungcip.better-toml
      # cpp tools
      # ms-vscode.cpptools
      # cmake support
      # twxs.cmake
      # python
      ms-python.python
      # spell checker
      streetsidesoftware.code-spell-checker
      # color picker
      # anseki.vscode-color
      # debug visualizer
      # hediet.debug-visualizer
      # docker support
      ms-azuretools.vscode-docker
      # eslint
      dbaeumer.vscode-eslint
      # gitlens
      eamodio.gitlens
      # liveserver
      ritwickdey.liveserver
      # material icon theme
      pkief.material-icon-theme
      # music time spotify
      # softwaredotcom.music-time
      # platformio
      # platformio.platformio-ide
      # rust
      matklad.rust-analyzer
      # sleig highlighting
      # carlmaragno.sleighighlight
      # synthwave theme
      # robbowen.synthwave-vscode
      # todo highlight
      gruntfuggly.todo-tree
      # tokyo night theme
      # enkia.tokyo-night
      # Vetur
      octref.vetur
      # protobuf
      zxh404.vscode-proto3
    ];

    package = pkgs.vscodium;
  };
}