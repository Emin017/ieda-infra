{
  stdenv,
  lib,
  fetchpatch,
  callPackage,
}:
let
  sources = ../_sources/generated.nix;
  deps = lib.filterAttrs (_: v: v ? src) (callPackage sources { });
  iEDASrc = deps.iEDA.src;
in
stdenv.mkDerivation {
  pname = "iEDA-src";
  version = deps.iEDA.date;
  src = iEDASrc;
  patches = [
    # This patch is to fix the build error caused by the missing of the header file,
    # and remove some libs or path that they hard-coded in the source code.
    # Should be removed after we upstream these changes.
    (fetchpatch {
      url = "https://github.com/Emin017/iEDA/commit/c17e42a3673afd9c7ace9374f85290a85354bb78.patch";
      hash = "sha256-xa1oSy3OZ5r0TigGywzpVPvpPnA7L6RIcNktfFen4AA=";
    })
    # This patch is to fix the compile error on the newer version of gcc/g++
    # We remove some forward declarations which are not allowed in newer versions of gcc/g++
    # Should be removed after we upstream these changes.
    (fetchpatch {
      url = "https://github.com/Emin017/iEDA/commit/f5464cc40a2c671c5d405f16b509e2fa8d54f7f1.patch";
      hash = "sha256-uVMV/CjkX9oLexHJbQvnEDOET/ZqsEPreI6EQb3Z79s=";
    })
  ];
  dontBuild = true;
  dontFixup = true;
  installPhase = ''
    cp -r . $out
  '';
}
