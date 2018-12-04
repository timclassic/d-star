{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs.pkgs; stdenv.mkDerivation {
  name = "generate-with-xetex";
  src = ./.;
  buildInputs = [
    (texlive.combine {
      inherit (texlive) scheme-basic xetex fontspec euenc xcolor parskip;
    })
  ];

  FONTCONFIG_FILE = makeFontsConf { fontDirectories = [ lmodern ]; };
}
