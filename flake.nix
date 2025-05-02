{
  description = "Minimal Quarto environment";

  inputs = {
    quarto-base.url = "github:asterikss/quarto-base-flake";

    nixpkgs.follows = "quarto-base/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      quarto-base,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = quarto-base.nixpkgsFor.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.quarto
          ];
          shellHook = ''
            exec fish
          '';
        };
      }
    );
}
