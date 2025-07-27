{
  lib,
  newScope,
  fetchgit,
}:
lib.makeScope newScope (scope: {
  iedaUnstable = scope.callPackage ./ieda.nix { iedaSrc = scope.iedaSrc; };
  iedaSrc = scope.callPackage ./src.nix {
    enablePrVersion = true;
    prVersion = "0-unstable-2025-07-27";
    prSrc = fetchgit {
      url = "https://gitee.com/oscc-project/iEDA";
      rev = "7c8f99328b758e407fc0359c231f1bc135751b79";
      sha256 = "sha256-n+6Um8Nmpc5zN4pShV+8kr3SEecEUxGRnG8SyGlaNZ0=";
      fetchSubmodules = true;
    };
  };
  rustpkgs = scope.callPackage ./rustpkgs { iedaSrc = scope.iedaSrc; };
  iir-rust = scope.rustpkgs.iir-rust;
  liberty-parser = scope.rustpkgs.liberty-parser;
  sdf-parse = scope.rustpkgs.sdf_parse;
  spef-parser = scope.rustpkgs.spef-parser;
  vcd-parser = scope.rustpkgs.vcd_parser;
  verilog-parser = scope.rustpkgs.verilog-parser;
})
