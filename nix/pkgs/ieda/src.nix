{
  stdenv,
  lib,
  fetchpatch,
  callPackage,
  enablePrVersion ? false,
  prSrc ? null,
  prVersion ? "",
}:
let
  sources = ../_sources/generated.nix;
  deps = lib.filterAttrs (_: v: v ? src) (callPackage sources { });
  srcAttrsSet =
    if enablePrVersion then
      {
        iEDASrc = prSrc;
        v = prVersion;
      }
    else
      {
        iEDASrc = deps.iEDA.src;
        v = deps.iEDA.version;
      };
in
stdenv.mkDerivation {
  pname = "iEDA-src";
  version = srcAttrsSet.v;
  src = srcAttrsSet.iEDASrc;

  patches = [
    # This patch is to fix the build error caused by the missing of the header file,
    # and remove some libs or path that they hard-coded in the source code.
    # Due to the way they organized the source code, it's hard to upstream this patch.
    # So we have to maintain this patch locally.
    ./patches/fix.patch
    ./patches/fix-tcl-include.patch
    # Comment out the iCTS test cases that will fail due to some linking issues on aarch64-linux
    (fetchpatch {
      url = "https://github.com/Emin017/iEDA/commit/87c5dded74bc452249e8e69f4a77dd1bed7445c2.patch";
      hash = "sha256-1Hd0DYnB5lVAoAcB1la5tDlox4cuQqApWDiiWtqWN0Q=";
    })
    ./patches/fix-cmake-require.patch
  ];

  dontBuild = true;
  dontFixup = true;
  installPhase = ''
    cp -r . $out
  '';
}
