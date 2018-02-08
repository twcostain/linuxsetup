#!/bin/python3

import argparse

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Wrapper that sets up a new ubuntu/linux machine.')
    parser.add_argument('--headless', required=True, action='store', choices=['True', 'False'])

    ARGS = parser.parse_args()

    print(ARGS.headless)
