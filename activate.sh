#!/bin/sh
set -e

cd $(dirname $0)
echo "Building CogiSystems configuration for host $(hostname) :)"

git pull

if [[ $1 == "--upgrade" ]]; then

    if ! git diff --staged --quiet; then
	echo "Commit the changes before running an upgrade!"
        exit 1
    fi

    nix flake update
    git add flake.lock flake.nix

    [[ -z $(git status | grep "Your branch is ahead of") ]] && read -p "Push? [y/N] " push
    
    git commit -m "Updated"

    [[ ${push^^} == "Y" || ${push^^} == "yes" ]] && git push 
fi

nixos-rebuild switch --impure --use-remote-sudo --flake . --show-trace $@
