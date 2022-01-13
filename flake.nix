{
  description = "YouTube comment counter web service (also install bracketcounter)";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  outputs = { self, nixpkgs, flake-utils }:
    {
      # Nixpkgs overlay providing the application
      overlay =
        (final: prev: {
          # The application
          bracketcounter-web = prev.pkgs.mkYarnPackage {
            src = ./.;
            name = "bracketcounter-web";
          };
        });
    } // (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        };
      in
        rec {
          packages.bracketcounter-web = pkgs.bracketcounter-web;
          defaultPackage = pkgs.bracketcounter-web;
        }));
}
