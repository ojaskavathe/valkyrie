{
  description = "wasm-react";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
        mini-redis =
          let
            pname = "mini-redis";
            version = "0.4.1";
          in
          pkgs.rustPlatform.buildRustPackage {
            inherit pname version;
            src = pkgs.fetchCrate {
              inherit pname version;
              hash = "sha256-vYphaQNMAHajod5oT/T3VJ12e6Qk5QOa5LQz6KsXvm8=";
            };
            cargoHash = "sha256-brl6YjDPnF064AhF1wRkJ7Ys3yLF88gKWTQaJz0/QQs=";

          };
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            buildInputs = [
              rust-bin.stable.latest.default
              rust-analyzer

              mini-redis
            ];
          };
      }
    );
}
