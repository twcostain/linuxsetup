#!/bin/bash
###################################
# Script to set up a linux box
# (c) Theo Costain 2019
###################################

set -e # Don't blindly continue after an error

source setup_functions.sh

SETUP_DIR=$(pwd);

cat install_options.txt

echo

read -p "Choose an option:" -n 1 -r OPTION

echo

case $OPTION in
    1)
        main
        ;;
    2)
        configure
        ;;
    3)
        configure
        install_miniconda || echo "Installing miniconda failed."
        ;;
    4)
        headless
        ;;
    5)
        headless_nosudo
        ;;
    6)
        install_latex
        ;;
    *)
        echo "Please choose a valid option"
        exit 1
        ;;
esac
