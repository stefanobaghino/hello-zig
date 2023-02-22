with import (fetchTarball {
  url = "https://github.com/nixos/nixpkgs/tarball/b139b6056c8ad4ef7e0cffb81304d59cf077589b";
  sha256 = "0sn9l19ckvdh227n0rfxk1cjnslhb5hr3g8czf3a436zkyfdl3if";
}) {};

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
      coreutils
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

    postPatch = ''
      # Zig's build looks at /usr/bin/env to find dynamic linking info. This
      # doesn't work in Nix' sandbox. Use env from our coreutils instead.
      substituteInPlace lib/std/zig/system/NativeTargetInfo.zig --replace "/usr/bin/env" "${coreutils}/bin/env"
    '';

    cmakeFlags = [
      # file RPATH_CHANGE could not write new RPATH
      "-DCMAKE_SKIP_BUILD_RPATH=ON"

      # ensure determinism in the compiler build
      "-DZIG_TARGET_MCPU=baseline"
    ];

    doCheck = true;
    installCheckPhase = ''
      $out/bin/zig test --cache-dir "$TMPDIR" -I $src/test $src/test/behavior.zig
    '';

  };
in
mkShell {
  nativeBuildInputs = [
    zig
  ];
}
