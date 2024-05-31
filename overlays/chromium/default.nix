# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{...}:

final: prev: {
  chromium = prev.chromium.override {
    ungoogled = true;
    enableWideVine = true;
  };
}
