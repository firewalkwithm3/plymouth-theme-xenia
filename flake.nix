{
  description = "plymouth-theme-xenia";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      plymouth-theme-xenia = (with pkgs; stdenvNoCC.mkDerivation {
          pname = "plymouth-theme-xenia";
          version = "1.0.0";
          src = ./.;
				  installPhase = ''
				    mkdir -p $out/share/plymouth/themes/xenia
				    cp -r $src/{*.plymouth,*.script,*.png} $out/share/plymouth/themes/xenia/
				    substituteInPlace $out/share/plymouth/themes/xenia/*.plymouth --replace '@IMAGES@' "$out/share/plymouth/themes/xenia"
				  '';
        }
      );
    in rec {
      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };
      defaultPackage = plymouth-theme-xenia;
      devShell = pkgs.mkShell {
        buildInputs = [
          plymouth-theme-xenia
        ];
      };
    }
  );
}



