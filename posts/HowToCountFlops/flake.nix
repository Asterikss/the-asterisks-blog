{
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
        packageOverrides = pkgs.callPackage ./python-packages.nix { };
        python = pkgs.python312.override { inherit packageOverrides; };

        extendedQuarto = quarto-base.lib.${system}.mkQuartoCustomPython {
          inherit python;
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
