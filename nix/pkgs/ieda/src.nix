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
    # Should be removed after we upstream these changes.
    ./patches/fix-cmake-headers.patch
    # This patch is to fix the compile error on the newer version of gcc/g++
    # We remove some forward declarations which are not allowed in newer versions of gcc/g++
    # Should be removed after we upstream these changes.
    (fetchpatch {
      url = "https://github.com/Emin017/iEDA/commit/f5464cc40a2c671c5d405f16b509e2fa8d54f7f1.patch";
      hash = "sha256-uVMV/CjkX9oLexHJbQvnEDOET/ZqsEPreI6EQb3Z79s=";
    })
  ];

  postPatch = ''
    # Comment out the line that adds the onnxruntime library path
    # Fail to patch this in the patch file, so we do it here. (Need to be figured out why)
    sed -i '27s/^/#/' src/operation/iSTA/CMakeLists.txt
  '';
  dontBuild = true;
  dontFixup = true;
  installPhase = ''
    cp -r . $out
  '';
}
