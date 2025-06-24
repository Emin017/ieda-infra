{
  pkgs,
  glog,
}:
let
  shell = pkgs.mkShell {
    buildInputs = with pkgs; [
      gtest
      glog
      gflags
      boost
      onnxruntime
      eigen
      yaml-cpp
      libunwind
      metis
      gmp
      tcl
      zlib
      gperftools
    ];
    nativeBuildInputs = with pkgs; [
      neovim
      cmake
      ninja
      flex
      bison
      tcl
      python3
    ];
  };
  closure = pkgs.closureInfo {
    rootPaths = [ shell.drvPath ];
  };
in
pkgs.runCommand "nix-env-wrapper"
  {
    pname = "nix-env-wrapper";
    meta.mainProgram = "nix-env-wrapper";
  }
  ''
    mkdir -p $out/bin
    cat > $out/bin/nix-env-wrapper <<EOF
    #!${pkgs.runtimeShell}
    export PATH=$PATH:${
      pkgs.lib.makeBinPath (
        with pkgs;
        [
          nix
          bashInteractive
        ]
      )
    }
    NIX_STATE_DIR=/nix/var/nix nix-store --load-db < ${closure}/registration
    exec nix-shell --option substituters "" ${shell.drvPath}
    EOF

    chmod +x $out/bin/nix-env-wrapper
  ''
