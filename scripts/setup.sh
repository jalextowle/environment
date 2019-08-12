#!/bin/bash

## The list of packages that should be installed or updated. 
packages=(
    ripgrep
)

## It's necessary to maintain a list of the command names associated with each package 
## because often package names are distince from the command names that they expose.
names=(
    rg
)

## If homebrew has not been installed, it will be installed before doing anything else.
## Otherwise, update homebrew.
if [[ $(command -v brew) == "" ]]; then
    echo "Installing Homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating Homebrew"
    brew update
fi

## Installs the package with the provided package and command name, and will update if it is
## already installed. This will only work for homebrew packages, which is why the installation 
## of homebrew itself does not use this function.
function install_or_upgrade {
    if [[ $(command -v "$1") == "" ]]; then
        echo "Installing "$2""
        brew install "$2"
    else
        echo "Updating "$2""
        brew outdated | grep -q "$2" && brew upgrade "$2" || echo "Already up-to-date."
    fi
}

## Get the length of the packages and names arrays and verify that they are the same.
package_length=${#packages[@]}
names_length=${#names[@]}

if [[ $package_length -ne $names_length ]]; then
    echo "Cannot install brew packages because the number of packages and names are not the same"
    exit 1
fi

for (( i=0; i<$package_length; i++ )); do
    install_or_upgrade ${names[i]} ${packages[i]}
done

## Install rustup so that rust can be installed
if [[ $(command -v rustup) == "" ]]; then
    echo "Installing rustup..."
    echo "Follow the instructions to ensure that rust is set up properly"
    curl https://sh.rustup.rs -sSf | sh
else
    echo "Updating rustup"
    rustup update
fi
