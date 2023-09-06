#!/bin/sh

cd $(dirname $0)
echo "Building CogiSystems configuration for host $(hostname) :)"
git pull 2> /dev/null

if [[ $1 == "--upgrade" ]]; then
	nix flake update
	git add flake.lock
	git commit -m "Updated"
fi

sudo nixos-rebuild switch --impure --flake . --show-trace $@
