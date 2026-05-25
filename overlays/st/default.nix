# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{...}:

# https://discourse.nixos.org/t/simple-terminal-st-setup/9763

final: prev: {
  st = prev.st.overrideAttrs (oldAttrs: rec {
    src = builtins.fetchTarball {
      url = "https://github.com/GiulioCocconi/st-cogi/archive/master.tar.gz";
      sha256 = "11kc3w6dizpzj5nm8w2kp6an3c8xlxp35c1qcjg7pdja48zrmjlr";
    };
    buildInputs = oldAttrs.buildInputs ++ [ prev.harfbuzz ];
  });
}
