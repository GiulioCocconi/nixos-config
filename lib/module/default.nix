# Copyright (c) 2024 Giulio Cocconi
# SPDX-License-Identifier: MIT

{lib, ...}:

with lib; rec {
  mkOpt = type: default: description:
    mkOption { inherit type default description; };

  mkBoolOpt = mkOpt types.bool;

  enabled = { enable = true; };
  disabled = { enable = mkForce false; };

  mkAssertion = a: msg:
    { assertion = a; message = msg; };

  mkAssertionModule = required_module: required_module_name: wanted_module_name:
    mkAssertion required_module.enable "${required_module_name} module must be enabled in order to use ${wanted_module_name}!";

}
