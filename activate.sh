#!/bin/sh
sudo nixos-rebuild switch --impure --flake . --show-trace
