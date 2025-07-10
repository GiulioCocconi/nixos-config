#!/bin/sh

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.10.0
# ARG_OPTIONAL_SINGLE([remote])
# ARG_OPTIONAL_SINGLE([hostname])
# ARG_OPTIONAL_BOOLEAN([upgrade])
# ARG_HELP([<The general help message of my script>])
# ARGBASH_GO

# [ <-- needed because of Argbash

hostname=$(hostname)

[[ -n "$_arg_remote" ]] && hostname="$_arg_remote"
[[ -n "$_arg_hostname" ]] && hostname="$_arg_hostname"


command_arguments=("--impure" "--sudo" "--flake" ".#$hostname" "--show-trace")

cd $(dirname $0)
echo "Building CoGiSystems configuration for $hostname"

if [[ "$_arg_upgrade" != "off" ]]; then
    if ! git diff --staged --quiet; then
	echo "Commit the changes before running an upgrade!"
        exit 1
    fi

    git pull
    
    nix flake update
    git add flake.lock flake.nix

    [[ -z $(git status | grep "Your branch is ahead of") ]] && read -p "Push? [y/N] " push
    
    git commit -m "Updated"

    [[ ${push^^} == "Y" || ${push^^} == "yes" ]] && git push 
   command_arguments+=("--upgrade")
fi

if [[ -n "$_arg_remote" ]]; then
    command_arguments+=("--target-host" "root@$_arg_remote")

fi

nixos-rebuild switch "${command_arguments[@]}"

# ] <-- needed because of Argbash
