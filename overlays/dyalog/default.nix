# Copyright (c) 2025 Giulio Cocconi
# SPDX-License-Identifier: MIT

{...}:

final: prev: {
  dyalog = prev.dyalog.override {
    acceptLicense = true;
    zeroFootprintRideSupport = true;
  };
}
