{
  stdenv,
  cmake,
  ninja,
  flex,
  bison,
  zlib,
  tcl,
  fetchgit,
  python3,
  python313Packages,
  boost,
}:

stdenv.mkDerivation {
  pname = "dreamplace";
  version = "4.2.1-unstable-2025-07-20";

  src = fetchgit {
    url = "https://github.com/Emin017/DREAMPlace.git";
    rev = "aa80b0d51f3be3201529ca9aa1e49d003bd6c17c";
    sha256 = "sha256-a5RqF/qDrWyLsIBgiKem0OE2PQmztrK+2UQEl8PdVpo=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    flex
    bison
    python3
    tcl
    python313Packages.matplotlib
    python313Packages.shapely
    python313Packages.numpy
    python313Packages.scipy
    python313Packages.patool
    python313Packages.cairocffi
    python313Packages.pkgconfig
    python313Packages.setuptools
    python313Packages.wheel
    python313Packages.distutils
  ];

  cmakeBuildType = "Release";

  cmakeFlags = [
    "-DCMAKE_CXX_ABI=1"
  ];

  preConfigure = ''
    cmakeFlags+=" -DCMAKE_INSTALL_PREFIX=$out -DPython_EXECUTABLE=${python3}/bin/python3"
  '';

  buildInputs = [
    zlib
    boost
    python313Packages.torch
  ];

  enableParallelBuild = true;
}
