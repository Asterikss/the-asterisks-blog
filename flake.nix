{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };

        # Create a function that can be used by other flakes to extend Quarto
        mkQuartoEnv =
          {
            extraPythonPackages ? (ps: [ ]),
          }:
          pkgs.quarto.override {
            extraPythonPackages = ps: extraPythonPackages ps;
          };
      in
      {
        # Export the function for other flakes to use
        lib = {
          inherit mkQuartoEnv;
        };

        devShells.default =
          with pkgs;
          mkShell {
            packages = [
              quarto
            ];
          };
      }
    );
}
