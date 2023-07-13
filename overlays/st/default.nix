{channels, ...}:

# https://discourse.nixos.org/t/simple-terminal-st-setup/9763

final: prev: {
  st = prev.st.overrideAttrs (oldAttrs: rec {
    src = builtins.fetchTarball {
	  url = "https://github.com/GiulioCocconi/st-cogi/archive/master.tar.gz";
	};
	buildInputs = oldAttrs.buildInputs ++ [ prev.harfbuzz ];
  });
}
