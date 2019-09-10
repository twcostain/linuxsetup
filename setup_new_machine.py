#!/bin/python3

import argparse
import subprocess

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Wrapper that sets up a new ubuntu/linux machine.')
    parser.add_argument('--latex', required=True, action='store', choices=['True', 'False'])
    parser.add_argument('--sublime', required=True, action='store', choices=['True', 'False'])
    #parser.add_argument('--', required=True, action='store', choices=['True', 'False'])

    ARGS = parser.parse_args()

    print("Running setup scripts")

    print("Doing basic setup")
    try:
        subprocess.run(['./newmachinesetup.sh'], check=True)
    except subprocess.CalledProcessError as err:
        print("Basic setup failed with error code: {}".format(err.returncode))

    if ARGS.sublime:
        print("Setting up sublime text")
        try:
            subprocess.run(['./setupsublime.sh'], check=True)
        except subprocess.CalledProcessError as err:
            print("Installing sublime text failed with error code: {}".format(err.returncode))

    if ARGS.latex:
        print("Installing LaTeX and Latexrun")
        try:
            subprocess.run(['./setuplatex.sh'], check=True)
        except subprocess.CalledProcessError as err:
            print("Installing LaTeX failed with error code: {}".format(err.returncode))

    print("Done all installations")
