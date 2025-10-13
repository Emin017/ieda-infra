{
  lib,
  newScope,
}:
lib.makeScope newScope (scope: {
  iedaUnstable = scope.callPackage ./ieda.nix { iedaSrc = scope.iedaSrc; };
  iedaSrc = scope.callPackage ./src.nix {
    enablePrVersion = false;
  };
  rustpkgs = scope.callPackage ./rustpkgs { iedaSrc = scope.iedaSrc; };
  iir-rust = scope.rustpkgs.iir-rust;
  liberty-parser = scope.rustpkgs.liberty-parser;
  sdf-parse = scope.rustpkgs.sdf_parse;
  spef-parser = scope.rustpkgs.spef-parser;
  vcd-parser = scope.rustpkgs.vcd_parser;
  verilog-parser = scope.rustpkgs.verilog-parser;
  releaseDocker = scope.callPackage ./docker.nix { };
})
