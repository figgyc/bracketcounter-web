{
  description = "YouTube comment counter web service (also install bracketcounter)";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";
  inputs.node2nix.url = "github:svanderburg/node2nix";
  inputs.node2nix.flake = false;

  outputs = { self, nixpkgs, flake-utils, node2nix }:
    {
      # Nixpkgs overlay providing the application
      overlay =
        (final: prev: {
          # The application
          bracketcounter-web = prev.pkgs.callPackage ./. {
            src = self;
            node2nix = (prev.pkgs.callPackage node2nix {}).package;
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
