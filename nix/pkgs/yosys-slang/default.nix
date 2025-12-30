{
  lib,
  stdenv,
  fetchgit,
  yosys,
  cmake,
}:
stdenv.mkDerivation rec {
  pname = "yosys-slang";
  version = "0-unstable-2025-12-16";
  plugin = "slang";

  src = fetchgit {
    url = "https://github.com/povik/yosys-slang.git";
    rev = "23e0653c85f6ed4127e665a2529b069ce550e967";
    sha256 = "sha256-7axr4JyxTtnCbI6l23A9LoBco3b3bqEMKoTEc1KNOQI=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DYOSYS_CONFIG=${yosys}/bin/yosys-config"
  ];

  buildInputs = [
    yosys
  ];

  nativeBuildInputs = [
    cmake
  ];

  installPhase = ''
    runHook preBuild

    mkdir -p $out/share/yosys/plugins
    install -m755 slang.so $out/share/yosys/plugins/

    runHook postBuild
  '';

  meta = {
    description = "SystemVerilog frontend for Yosys ";
    homepage = "https://github.com/povik/yosys-slang";
    license = lib.licenses.isc;
  };
}
