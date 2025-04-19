{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    quarto-base.url = "../../.";
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
        pkgs = import nixpkgs { inherit system; };

        extendedQuarto = quarto-base.lib.${system}.mkQuartoEnv {
          extraPythonPackages =
            ps: with ps; [
              torch
              torchinfo
              fvcore
              # ptflops
              # calflop
            ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            extendedQuarto
          ];
          shellHook = ''
            exec fish
          '';
        };
      }
    );
}
