{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, cmake
, pkg-config
, qtbase
, qtsvg
, qttools
, qtwebengine
, qt5compat
, python3Packages
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sigil";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "Sigil-Ebook";
    repo = "Sigil";
    rev = finalAttrs.version;
    hash = "sha256-fWlN+3C3CgX59TSWefTN6WyTxnpPWvBQRExqDGCfjoQ=";
  };

  pythonPath = with python3Packages; [ lxml ];

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];

  buildInputs = [
    qtbase qtsvg qttools qtwebengine qt5compat
    python3Packages.lxml
  ];

  prePatch = ''
    sed -i '/^QTLIB_DIR=/ d' src/Resource_Files/bash/sigil-sh_install
  '';

  dontWrapQtApps = true;

  preFixup = ''
    wrapProgram "$out/bin/sigil" \
       --prefix PYTHONPATH : $PYTHONPATH \
       ''${qtWrapperArgs[@]}
  '';

  meta = with lib; {
    description = "Free, open source, multi-platform ebook (ePub) editor";
    homepage = "https://github.com/Sigil-Ebook/Sigil/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jtbx ];
    platforms = platforms.linux;
    mainProgram = "sigil";
  };
})
