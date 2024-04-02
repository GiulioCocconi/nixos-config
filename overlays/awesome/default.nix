# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{...}:
final: prev:
{
  awesome = prev.awesome.override {
    lua = prev.luajit;
  };
}
