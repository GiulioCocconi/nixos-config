{...}:
final: prev: {

  mathematica = prev.mathematica.override {
    source = prev.requireFile {
      name = "Mathematica.sh";
      sha256 = "1zzwpx12prszwwhc0xx15riid0c6psh63s5nnn6dna9ds6yi0qvg";
      hashMode = "recursive";
      message = ''
        The installer is not present! To install matematica, first download the installer from
        `https://wolfram.com/download-center/mathematica/`.
        Then run `nix-store --query --hash $(nix store add-path Mathematica_XX.X.X_BNDL_LINUX.sh --name 'Mathematica.sh')` in order to make it available and find the hash.
        
      '';
    };
  };
}
