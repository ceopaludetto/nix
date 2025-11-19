{ inputs, pkgs, ... }:
{
  imports = [
    inputs.dms.homeModules.dankMaterialShell.default
  ];

  programs.dankMaterialShell.enable = true;
  programs.dankMaterialShell.systemd.enable = true;

  programs.dankMaterialShell.plugins.Calculator.enable = true;
  programs.dankMaterialShell.plugins.Calculator.src = pkgs.fetchFromGitHub {
    owner = "rochacbruno";
    repo = "DankCalculator";
    rev = "de6dbd59b7630e897a50e107f704c1cd4a131128";
    sha256 = "sha256-Vq+E2F2Ym5JdzjpCusRMDXd6uuAhhjAehyD/tO3omdY=";
  };

  programs.dankMaterialShell.plugins.WebSearch.enable = true;
  programs.dankMaterialShell.plugins.WebSearch.src = pkgs.fetchFromGitHub {
    owner = "devnullvoid";
    repo = "dms-web-search";
    rev = "1d6cacb02365631cf30ad1fef60224a42faf432c";
    sha256 = "sha256-fb+JRRtSk5+q3jivs8MWeJuPyQbOIhw2owEI97n5pGA=";
  };
}
