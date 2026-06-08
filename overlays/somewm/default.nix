# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{inputs, ...}:
final: prev:
{
  somewm = inputs.somewm.packages.${prev.stdenv.hostPlatform.system}.default; 
}
