{
  description = "Blizzard development shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/d6df3513510a";

  outputs = { nixpkgs, ... }:
    let
      systems = [ "aarch64-linux" "x86_64-linux" ];
    in {
      devShells = nixpkgs.lib.genAttrs systems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          # ponytail: nixpkgs is older than DCM GA; use its package when it reaches CLI 3.24+.
          snow = pkgs.writeShellScriptBin "snow" ''
            exec ${pkgs.uv}/bin/uvx \
              --python ${pkgs.python313}/bin/python3.13 \
              --from snowflake-cli==3.27.0 \
              snow "$@"
          '';
        in {
          default = pkgs.mkShell {
            packages = [
              pkgs.just
              pkgs.terraform
              snow
            ];
          };
        });
    };
}
