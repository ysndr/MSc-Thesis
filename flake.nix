{
  description = "Master Thesis";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.writing-tools.url = "github:ysndr/writing-tools";
  inputs.writing-tools.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, writing-tools }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        writing = writing-tools.packages.${system};

        latex = (writing.latex.override { });

        compile-all = pkgs.writeShellScriptBin "compile-thesis" ''
          pandoc $(cat ./toc.txt) --defaults document.yaml -o "$@"
        '';

        compile-toc = pkgs.writeShellScriptBin "compile-toc" ''
          pandoc $(cat ./toc.txt) --defaults document.yaml  -t markdown --toc --template table-of-contents.md.template --toc-depth=4 \
          | pandoc --defaults document.yaml -o $@
        '';

        compile-chapter-preview = pkgs.writeShellScriptBin "compile-chapter-preview" ''
          pandoc prelude/metadata.yaml prelude/prelude.md $1 --defaults document.yaml -o "''${@:2}"
        '';


      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = [
            latex
            (writing.pandoc.override {
              inherit latex;
              filters = [
                "pandoc-include-code"
                (builtins.fetchurl "https://raw.githubusercontent.com/ysndr/pandocfilters/7bee1ae/examples/plantuml.py")
                (builtins.fetchurl "https://raw.githubusercontent.com/jgm/pandocfilters/f850b22/examples/graphviz.py")
                (builtins.fetchurl "https://raw.githubusercontent.com/jgm/pandocfilters/f850b22/examples/tikz.py")
                (builtins.fetchurl "https://raw.githubusercontent.com/timofurrer/pandoc-plantuml-filter/master/pandoc_plantuml_filter.py")
                (pkgs.writeShellScript "pandoc-mermaid" ''
                  MERMAID_BIN=${pkgs.nodePackages.mermaid-cli}/bin/mmdc exec python ${builtins.fetchurl "https://raw.githubusercontent.com/timofurrer/pandoc-mermaid-filter/master/pandoc_mermaid_filter.py"}
                '')
                (pkgs.runCommand "pandoc-crossref" { } ''
                  ln -s ${pkgs.haskellPackages.pandoc-crossref}/bin/pandoc-crossref $out
                '')
                # (builtins.fetchurl "https://raw.githubusercontent.com/tomduck/pandoc-fignos/master/pandoc_fignos.py")
              ];
              citeproc = true;
              extraPackages = [ pkgs.graphviz pkgs.plantuml pkgs.haskellPackages.pandoc-include-code ];
              pythonExtra = p: [ p.pygraphviz p.psutil ];
            })
            compile-all
            compile-toc
            compile-chapter-preview

            pkgs.graphviz pkgs.plantuml
          ];
        };
      });
}
