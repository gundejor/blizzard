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
          # ponytail: nixpkgs' CLI snapshot tests currently fail; remove when the package builds normally.
          snowflake-cli = pkgs.snowflake-cli.overridePythonAttrs (_: { doCheck = false; });
        in {
          default = pkgs.mkShell {
            packages = [
              pkgs.terraform
              snowflake-cli
            ];
          };
        });
    };
}
