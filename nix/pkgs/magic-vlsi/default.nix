{
  lib,
  stdenv,
  fetchFromGitHub,
  git,
  python3,
  m4,
  cairo,
  libX11,
  mesa_glu,
  ncurses,
  tcl,
  tcsh,
  tk,
}:

stdenv.mkDerivation rec {
  pname = "magic-vlsi";
  version = "8.3.530";

  src = fetchFromGitHub {
    owner = "RTimothyEdwards";
    repo = "magic";
    tag = "${version}";
    sha256 = "sha256-OQPOEDcU0BuGdI7+saOTntosa8+mQcGbZuwzIlvRBSk=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [
    python3
    git
  ];

  buildInputs = [
    cairo
    libX11
    m4
    mesa_glu
    ncurses
    tcl
    tcsh
    tk
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tcl=${tcl}"
    "--with-tk=${tk}"
    "--disable-werror"
  ];

  postPatch = ''
    patchShebangs scripts/*
  '';

  postInstall = ''
    # Create the sys directory
    mkdir -p ${placeholder "out"}/lib/magic/sys

    # Install all technology files that were generated
    for techfile in scmos/*.tech; do
      if [ -f "$techfile" ]; then
        install -Dm644 "$techfile" ${placeholder "out"}/lib/magic/sys/$(basename "$techfile")
      fi
    done

    # Install all display styles
    for dstylefile in scmos/*.dstyle; do
      if [ -f "$dstylefile" ]; then
        install -Dm644 "$dstylefile" ${placeholder "out"}/lib/magic/sys/$(basename "$dstylefile")
      fi
    done

    # Install all color maps
    for cmapfile in scmos/*.cmap; do
      if [ -f "$cmapfile" ]; then
        install -Dm644 "$cmapfile" ${placeholder "out"}/lib/magic/sys/$(basename "$cmapfile")
      fi
    done
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  meta = with lib; {
    description = "VLSI layout tool written in Tcl";
    homepage = "http://opencircuitdesign.com/magic/";
    license = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
