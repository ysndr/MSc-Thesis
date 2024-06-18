{
  inputs.parent.url = "../.";

  outputs = { parent, ... }: parent.inputs.flake-utils.lib.eachDefaultSystem (system:
    let

      pkgs = parent.inputs.nixpkgs.legacyPackages.${system};
      jupyter = pkgs.python3.withPackages (ps: with ps; [
        autopep8
        
        notebook
        
        numpy
        scipy
        pandas
        matplotlib seaborn plotly
      ]);

    in
    {
      devShells.default = jupyter.env.overrideAttrs (old: {
        shellHook= ''
          echo
          echo ">>> INFO >>>"
          echo
          echo "Using python installation at: $(which python)"
          echo
          echo "<<< INFO <<<"
          echo
        '';


      });
    });

}
