{
  inputs.utils = {
    url = "github:numtide/flake-utils";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  inputs.latex.url = "github:leixb/latex-template";

  outputs = { self, nixpkgs, utils, latex }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        dev-packages = with pkgs; [
          texlab
          zathura
          wmctrl
          which
          python39Packages.pygments
        ];

        SOURCE_DATE_EPOCH = 1653516000; # 2022-05-26

        texlive = pkgs.texlive.combined.scheme-full;
      in
      rec {
        devShell = pkgs.mkShell {
          name = "texlive";
          buildInputs = [ dev-packages texlive ];
          inherit SOURCE_DATE_EPOCH;
        };

        packages.document = latex.lib.latexmk {
          inherit pkgs texlive SOURCE_DATE_EPOCH;
          src = ./.;
          shellEscape = true;
          minted = true;
          name = "DOC_BoneSalvan.pdf";
        };

        defaultPackage = packages.document;
      }
    );
}
