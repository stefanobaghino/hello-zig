with import <nixpkgs> {};

mkShell {
  nativeBuildInputs = [
    zig
  ];
}
