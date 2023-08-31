{
  description = "LaTeX Build Environment";
  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;
    flake-utils.url = github:numtide/flake-utils;
  };
  outputs = { self, nixpkgs, flake-utils }:
    with flake-utils.lib; eachSystem allSystems (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      tex = pkgs.texlive.combine {
          inherit (pkgs.texlive)
            scheme-small latex-bin latexmk
            minted beamer booktabs inter fontaxes
          ;
      };
      build_pkgs = [
        tex
        (pkgs.python311.withPackages(ps: with ps; [ pygments ]))
      ];
    in rec {
      packages.document = pkgs.stdenvNoCC.mkDerivation rec {
          name = "latex-demo-document";
          src = self;
          buildInputs = [ pkgs.coreutils ] ++ build_pkgs;
          phases = ["unpackPhase" "buildPhase" "installPhase"];
          buildPhase = ''
            export PATH="${pkgs.lib.makeBinPath buildInputs}";
            mkdir -p .cache/texmf-var
            env TEXMFHOME=.cache TEXMFVAR=.cache/texmf-var \
              latexmk -interaction=nonstopmode -pdf -lualatex \
              main.tex
          '';
          installPhase = ''
            mkdir -p $out
            cp document.pdf $out/
          '';
      };
      defaultPackage = packages.document;

      devShell = pkgs.mkShell { buildInputs = build_pkgs; };
    });
}
