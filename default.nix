with import <nixpkgs> {}; {
  paletteInsightDeployEnv = pkgs.stdenv.mkDerivation rec {
    name = "palette-insight-deploy-env";
    buildInputs = [ pkgs.stdenv pkgs.qemu pkgs.packer pkgs.ansible2 ];
  };
}
