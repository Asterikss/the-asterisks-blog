{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    quarto-base.url = "../../nix/.";
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
        packageOverrides = pkgs.callPackage ./python-packages.nix { };
        python = pkgs.python312.override { inherit packageOverrides; };

        # extendedQuarto = quarto-base.lib.${system}.mkQuartoEnv {
        #   extraPythonPackages =
        #     ps: with ps; [
        #       torch
        #       torchinfo
        #       fvcore
        #     ];
        # };

        extendedQuarto = quarto-base.lib.${system}.mkQuartoCustomPython {
          python = python;
          extraPythonPackages =
            ps: with ps; [
              torch
              torchinfo
              fvcore
              # Custom package available through packageOverrides
              pyperclip3
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
