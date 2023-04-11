#!/usr/bin/env python3

"""Convert clip samplesheet into an input that ultraplex can read."""

import platform
import argparse
from sys import exit
import pandas as pd


def dump_versions(process_name):
    with open("versions.yml", "w") as out_f:
        out_f.write(process_name + ":\n")
        out_f.write("    python: " + platform.python_version() + "\n")
        out_f.write("    pandas: " + pd.__version__ + "\n")


def main(process_name, samplesheet, output):
    # Dump version file
    dump_versions(process_name)

    # Read CSV file into dataframe
    df_samplesheet = pd.read_csv(samplesheet, dtype=str, keep_default_na=False)

    # Check for unique adapter sequences
    adapters = df_samplesheet["3' Adapter Sequence"].unique()
    if len(adapters) > 1:
        print("ERROR: 3' Adapter mismatch in sample sheet. Mixed adapter sequences are not allowed in the sample sheet.")
        print(adapters)
        exit(1)

    # Init for loop
    five_prime = df_samplesheet["5' Barcode Sequence"]
    three_prime = df_samplesheet["3' Barcode Sequence"]
    sample_names = df_samplesheet["Sample Name"]
    barcode_dict = {}

    # Create barcode dict
    for idx in range(len(five_prime)):
        barcode_dict.setdefault(five_prime[idx], [])
        barcode_dict[five_prime[idx]].append(three_prime[idx] + ":" + sample_names[idx])

    # Write to file with error checking
    with open(output, "w") as out_f:
        for five, threes in barcode_dict.items():
            if len(threes) > 1:
                if any([three.startswith(":") for three in threes]):
                    print("ERROR: 5' barcode ambiguity between samples")
                    exit(1)

                out_f.write(",".join([five] + threes) + "\n")
            else:
                if not threes[0].startswith(":"):
                    threes[0] = "," + threes[0]

                out_f.write(five + threes[0] + "\n")


if __name__ == "__main__":
    # Allows switching between nextflow templating and standalone python running using arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--process_name", default="!{process_name}")
    parser.add_argument("--samplesheet", default="!{samplesheet}")
    parser.add_argument("--output", default="!{output}")
    args = parser.parse_args()

    main(args.process_name, args.samplesheet, args.output)
