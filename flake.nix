{
  description = "Locally modified OpenTabletDriver";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default =

        let

          deps = with pkgs; [
            dotnetCorePackages.sdk_10_0
            gtk3
            libappindicator
            libevdev
            libnotify
            libx11
            libxrandr
            udev
          ];
        in
        pkgs.mkShell {
          inputsFrom = [
          ];
          buildInputs = deps;
          shellHook = ''
            export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath (deps)}:$LD_LIBRARY_PATH"
          '';
        };
      packages.${system} = {
        opentabletdriver = pkgs.callPackage ./package.nix { };
        default = self.packages.${system}.opentabletdriver;
      };
      overlays.default = final: prev: {
        opentabletdriver = self.packages.${prev.system}.opentabletdriver;
      };
    };
}
