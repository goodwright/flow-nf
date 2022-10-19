#!/usr/bin/env python3

"""Convert an excel sheet to csv"""

import platform
import argparse
import pandas as pd


def dump_versions(process_name):
    with open("versions.yml", "w") as out_f:
        out_f.write(process_name + ":\n")
        out_f.write("    python: " + platform.python_version() + "\n")
        out_f.write("    pandas: " + pd.__version__ + "\n")


def main(process_name, xlsx, output):
    # Dump version file
    dump_versions(process_name)

    # Convert excel file
    data = pd.read_excel(xlsx, engine='openpyxl')
    data.to_csv(output, index=False)


if __name__ == "__main__":

    # Allows switching between nextflow templating and standalone python running using arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--process_name", default="!{process_name}")
    parser.add_argument("--xlsx", default="!{xlsx}")
    parser.add_argument("--output", default="!{output}")
    args = parser.parse_args()

    main(args.process_name, args.xlsx, args.output)
