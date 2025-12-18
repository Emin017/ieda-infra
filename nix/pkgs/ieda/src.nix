{
  stdenv,
  lib,
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
  ];

  dontBuild = true;
  dontFixup = true;
  installPhase = ''
    cp -r . $out
  '';
}
