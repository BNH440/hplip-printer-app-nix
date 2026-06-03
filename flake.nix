{
  description = "HPLIP Printer Application";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      pappl-retrofit = pkgs.callPackage ./pappl-retrofit.nix { };
    in {
      packages.${system}.default = pkgs.callPackage ./package.nix {
        inherit pappl-retrofit;
      };
    };
}