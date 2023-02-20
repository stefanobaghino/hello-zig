with import <nixpkgs> {};

let
  zig = stdenv.mkDerivation rec {

    name = "zig";

    src = fetchFromGitHub {
      owner = "ziglang";
      repo = "zig";
      rev = "476bdc8b0b02cbd09f6a856aa7dc548dea565109";
      hash = "sha256-VdMNzvoWNGvVFiblE7vajOetmHa0hyUWw5tWWVZjKEs=";
    };

    nativeBuildInputs = [
      cmake
      llvmPackages_15.llvm.dev
    ];

    buildInputs = [
      libxml2
      zlib
    ] ++ (with llvmPackages_15; [
      libclang
      lld
      llvm
    ]);

    preBuild = ''
      export HOME=$TMPDIR;
    '';

    cmakeFlags = [
      # file RPATH_CHANGE could not write new RPATH
      "-DCMAKE_SKIP_BUILD_RPATH=ON"
    ];

    doCheck = false; # YOLO
  };
in
mkShell {
  nativeBuildInputs = [
    zig
  ];
}
