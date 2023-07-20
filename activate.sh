#!/bin/sh

cd $(dirname $0)
echo "Building CogiSystems configuration for host $(hostname) :)"
git pull 2> /dev/null
sudo nixos-rebuild switch --impure --flake . --show-trace $@
