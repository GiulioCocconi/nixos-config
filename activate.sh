#!/bin/sh
echo "Building CogiSystems configuration for host $(hostname) :)"
sudo nixos-rebuild switch --impure --flake . --show-trace $@
