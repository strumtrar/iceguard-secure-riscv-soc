{
  description = "ptx project";

  nixConfig.extra-experimental-features = "nix-command flakes ca-references";

  inputs =
    {
      nixpkgs.url = "github:NixOS/nixpkgs/master";
      flake-parts.url = "github:hercules-ci/flake-parts";
      devshell.url = "github:numtide/devshell";
    };

  outputs =
    inputs @{ self
            , devshell
            , flake-parts
            , nixpkgs
            , ...
            }:
    flake-parts.lib.mkFlake { inherit inputs; } ({ ... }: {
      debug = true;
      systems = [ "x86_64-linux" ];
      imports = [
        devshell.flakeModule
      ];

      perSystem =
        {
          pkgs
        , ...
        }: {
          devshells.default = { pkgs, ... }: {
            packages = [
              pkgs.dt-schema
              pkgs.gum
              pkgs.gitFull
              pkgs.just
              pkgs.microcom
              pkgs.watchexec
              pkgs.yosys
              pkgs.nextpnr
              pkgs.trellis
              pkgs.iverilog
              pkgs.openfpgaloader
              pkgs.python3Packages.migen
              pkgs.python3Packages.distutils
              pkgs.python3Packages.jinja2
              pkgs.pkgsCross.riscv64.buildPackages.gcc
            ];
	  };
	};
      });
}

