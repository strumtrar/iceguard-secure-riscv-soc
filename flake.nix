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
	      (pkgs.python310.withPackages (pypkgs: [
	              pypkgs.migen
  		      pypkgs.meson
	      ]))
              pkgs.pkgsCross.riscv64.buildPackages.gcc
              pkgs.pkgsCross.riscv64.buildPackages.binutils
              pkgs.pkgsCross.riscv32.buildPackages.gcc
              pkgs.pkgsCross.riscv32.buildPackages.binutils
            ];
	  };
	};
      });
}

