{config, inputs, ...}:
let
  stable = import inputs.nixpkgs-stable { config = config.nixpkgs.config; };
in
final: prev: {
  let stableMathematica = inputs.nixpkgs-stable.legacyPackages.${final.system}.mathematica; in
  mathematica = stableMathematica.override {
    source = prev.requireFile {
      name = "Mathematica.sh";
      sha256 = "0rmrspvf1aqgpvl9g53xmibw28f83vzrrhw6dmfm4l7y05cr315y";
      hashMode = "recursive";
      message = ''
        The installer is not present! To install matematica, first download the installer from
        https://wolfram.com/download-center/mathematica/.
        Then run "nix-store --query --hash \$(nix store add-path Mathematica_XX.X.X_BNDL_LINUX.sh --name 'Mathematica.sh')" in order to make it available and find the hash.

      '';
    };
  };
}
