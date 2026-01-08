
# Copyright (c) 2025 Giulio Cocconi
# SPDX-License-Identifier: MIT

{...}:

final: prev: {
  prismlauncher-unwrapped = prev.prismlauncher-unwrapped.overrideAttrs (oldAttrs: rec {
    patches = [ ./offline.patch ];
  });
}
