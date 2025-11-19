{ homeDirectory, stdenv, ... }:
stdenv.mkDerivation rec {
  pname = "dankshell-theme";
  version = "1.0.0";

  src = ../../../assets/templates/vscode;

  dontBuild = true;
  dontConfigure = true;

  vscodeExtUniqueId = "dankshell.dankshell-theme";
  vscodeExtPublisher = "dankshell";

  installPhase = ''
    mkdir -p $out/share/vscode/extensions/${vscodeExtUniqueId}

    # Copy your files
    cp package.json $out/share/vscode/extensions/${vscodeExtUniqueId}/
    cp extension.vsixmanifest $out/share/vscode/extensions/${vscodeExtUniqueId}/

    # Symlink
    mkdir -p $out/share/vscode/extensions/${vscodeExtUniqueId}/themes
    ln -s ${homeDirectory}/.config/vscode-oss/themes/matugen.json $out/share/vscode/extensions/${vscodeExtUniqueId}/themes/dankshell-default.json
  '';
}
