{
  stdenv,
  fetchgit,
  fetchpatch,
}:
stdenv.mkDerivation {
  pname = "iEDA-src";
  version = "0-unstable-2025-06-05";
  src = fetchgit {
    url = "https://gitee.com/oscc-project/iEDA";
    rev = "7afa129e1dd2274e0c800ad7a6daa3219d06bf59";
    sha256 = "sha256-rP8hs4+5DfGLIOhphm3DsyOyOm/tP+/sd8Q6XS0FEaA=";
    fetchSubmodules = true;
  };

  postPatch = ''
    # Comment out the iCTS test cases that will fail due to some linking issues on aarch64-linux
    sed -i '17,28s/^/# /' src/operation/iCTS/test/CMakeLists.txt
  '';

  patches = [
    # This patch is to fix the build error caused by the missing of the header file,
    # and remove some libs or path that they hard-coded in the source code.
    # Should be removed after we upstream these changes.
    (fetchpatch {
      url = "https://github.com/Emin017/iEDA/commit/e899b432776010048b558a939ad9ba17452cb44f.patch";
      hash = "sha256-fLKsb/dgbT1mFCWEldFwhyrA1HSkKGMAbAs/IxV9pwM=";
    })
    # This patch is to fix the compile error on the newer version of gcc/g++
    # which is caused by some incorrect declarations and usages of the Boost library.
    # Should be removed after we upstream these changes.
    (fetchpatch {
      url = "https://github.com/Emin017/iEDA/commit/f5464cc40a2c671c5d405f16b509e2fa8d54f7f1.patch";
      hash = "sha256-uVMV/CjkX9oLexHJbQvnEDOET/ZqsEPreI6EQb3Z79s=";
    })
    # This patch is to fix the glog compatibility issue with the 0.7.1 version glog
    ./patches/glog.patch
  ];
  dontBuild = true;
  dontFixup = true;
  installPhase = ''
    cp -r . $out
  '';
}
