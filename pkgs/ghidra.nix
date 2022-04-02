{ stdenv
, fetchzip
, lib
, makeWrapper
, autoPatchelfHook
, adoptopenjdk-hotspot-bin-16
, pam
, makeDesktopItem
, icoutils
}:

# TODO: convert to my own ghidra fork
let
  pkg_path = "$out/lib/ghidra";
  pname = "ghidra";
  version = "10.0.3";

  desktopItem = makeDesktopItem {
    name = "ghidra";
    exec = "ghidra";
    icon = "ghidra";
    desktopName = "Ghidra";
    genericName = "Ghidra Software Reverse Engineering Suite";
    categories = "Development;";
  };

in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchzip {
    url = "https://github.com/suicidesquad1337/ghidra/releases/download/2021-09-08/release.zip";
    sha256 = "sha256-joUy024Cq4yUwMRjxoL65ANPmNSqjUrPWludG3rFR/4=";
  };

  nativeBuildInputs = [
    makeWrapper
    icoutils
  ]
  ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  buildInputs = [
    stdenv.cc.cc.lib
    pam
  ];

  dontStrip = true;

  installPhase = ''
    mkdir -p "${pkg_path}"
    mkdir -p "${pkg_path}" "$out/share/applications"
    cp -a * "${pkg_path}"
    ln -s ${desktopItem}/share/applications/* $out/share/applications
    icotool -x "${pkg_path}/support/ghidra.ico"
    rm ghidra_4_40x40x32.png
    for f in ghidra_*.png; do
      res=$(basename "$f" ".png" | cut -d"_" -f3 | cut -d"x" -f1-2)
      mkdir -pv "$out/share/icons/hicolor/$res/apps"
      mv "$f" "$out/share/icons/hicolor/$res/apps/ghidra.png"
    done;
  '';

  postFixup = ''
    mkdir -p "$out/bin"
    makeWrapper "${pkg_path}/ghidraRun" "$out/bin/ghidra" \
      --prefix PATH : ${lib.makeBinPath [ adoptopenjdk-hotspot-bin-16 ]}
  '';
}