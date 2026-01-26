{
  description = "Isolated Python development environment";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-25.11";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        {
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              python3
              uv
              just
            ];

            shellHook = ''
              # Prevent Python from looking in user site-packages or system site-packages
              export PYTHONNOUSERSITE=1
              
              # Initialize uv project if pyproject.toml doesn't exist
              if [ ! -f "pyproject.toml" ]; then
                uv init --no-readme 2>/dev/null || true
              fi
              
              # Sync virtual environment with uv
              uv sync --frozen 2>/dev/null || uv sync
              
              # Activate virtual environment (uv creates .venv automatically)
              if [ -d ".venv" ]; then
                source .venv/bin/activate
              fi
              
              # echo "Isolated Python environment (using uv)"
              # echo "Python version: $(python --version)"
              # echo "Uv version: $(uv --version)"
              # echo ""
              # echo "Install packages with: uv add <package>"
              # echo "Packages are isolated to .venv/ and tracked in pyproject.toml"
            '';
          };
        }
      );
    };
}
