{
  description = "A basic flake with a shell";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.writing-tools.url = "github:ysndr/writing-tools";
  inputs.writing-tools.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils, writing-tools }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        writing = writing-tools.packages.${system};



        compile-all = pkgs.writeShellScriptBin "compile-thesis" ''
          pandoc $(cat ./toc.txt) -o "$@"
        '';

        compile-chapter-preview = pkgs.writeShellScriptBin "compile-chapter-preview" ''
          pandoc $1 -o "''${@:2}"
        '';

      in
      {
        devShell = pkgs.mkShell {
          nativeBuildInputs = [ pkgs.bashInteractive ];
          buildInputs = [
            writing.latex
            (writing.pandoc.override {
              filters = [
                (pkgs.runCommand "pandoc-crossref" { } ''
                  ln -s ${pkgs.haskellPackages.pandoc-crossref}/bin/pandoc-crossref $out
                '')
                (builtins.fetchurl "https://raw.githubusercontent.com/jgm/pandocfilters/f850b22/examples/graphviz.py")
                (builtins.fetchurl "https://raw.githubusercontent.com/jgm/pandocfilters/f850b22/examples/tikz.py")
                (pkgs.writeShellScript "pandoc-mermaid" ''
                  MERMAID_BIN=${pkgs.nodePackages.mermaid-cli}/bin/mmdc exec python ${builtins.fetchurl "https://raw.githubusercontent.com/timofurrer/pandoc-mermaid-filter/master/pandoc_mermaid_filter.py"}
                '')
                # (builtins.fetchurl "https://raw.githubusercontent.com/tomduck/pandoc-fignos/master/pandoc_fignos.py")
              ];
              extraPackages = [ pkgs.graphviz ];
              pythonExtra = p: [ p.pygraphviz p.psutil ];
            })
            compile-all
            compile-chapter-preview
          ];
        };
      });
}
