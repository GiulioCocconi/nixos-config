#!/bin/sh
set -e

cd $(dirname $0)
echo "Building CogiSystems configuration for host $(hostname) :)"

if [[ $1 == "--upgrade" ]]; then

    if ! git diff --staged --quiet; then
		echo "Commit the changes before running an upgrade!"
        exit 1
    fi

	nix flake update
	git add flake.lock flake.nix
	git commit -m "Updated"
fi

sudo nixos-rebuild switch --impure --flake . --show-trace $@
