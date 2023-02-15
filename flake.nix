{
  inputs = {
    opam-nix.url = "github:tweag/opam-nix";
    flake-utils.url = "github:numtide/flake-utils";
    opam-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = { self, nixpkgs, flake-utils, opam-nix }@inputs:
    let package = "ipaddr";
    in flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        opam-nix-lib = opam-nix.lib.${system};
        devPackagesQuery = {
          ocaml-lsp-server = "*";
          ocamlformat = "*";
        };
        query = {
          ocaml-base-compiler = "*";
        };
        resolved-scope = opam-nix-lib.buildOpamProject' { } ./. query // devPackagesQuery;
      in rec {
        packages = resolved-scope // { default = resolved-scope.${package}; };
        defaultPackage = packages.default;
      });
}
