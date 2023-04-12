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
    # Init
    df_samplesheet = None

    # Dump version file
    dump_versions(process_name)

    # Check for multiple samplesheets and merge them together
    samplesheet_list = args.samplesheet.split(" ")
    if len(samplesheet_list) > 1:
        print("Multiple samplesheets detected")
        df_samplesheets = []
        for samplesheet in samplesheet_list:
            df_samplesheets.append(pd.read_csv(samplesheet, dtype=str, keep_default_na=False))

        for idx, df in enumerate(df_samplesheets):
            if idx == 0:
                df_samplesheet = df
            else:
                df_samplesheet = pd.concat([df_samplesheet, df], ignore_index=True)
    else:
        # Read CSV file into dataframe
        df_samplesheet = pd.read_csv(samplesheet, dtype=str, keep_default_na=False)

    # Check for unique adapter sequences
    adapters = df_samplesheet["3' Adapter Sequence"].unique()
    if len(adapters) > 1:
        print(
            "ERROR: 3' Adapter mismatch in sample sheet. Mixed adapter sequences are not allowed in the sample sheet."
        )
        print(adapters)
        exit(1)

    # Init for loop
    five_prime = df_samplesheet["5' Barcode Sequence"]
    three_prime = df_samplesheet["3' Barcode Sequence"]
    sample_names = df_samplesheet["Sample Name"]
    barcode_dict = {}

    # Create barcode dict of all five prime barcodes with an array in each dict 
    # pos with a string comprised of the three prime : sample name
    for idx in range(len(five_prime)):
        barcode_dict.setdefault(five_prime[idx], [])
        barcode_dict[five_prime[idx]].append(three_prime[idx] + ":" + sample_names[idx])

    # Write to file with error checking
    with open(output, "w") as out_f:
        for key, val in barcode_dict.items():
            # Do we have more than one sample assigned to the five prime barcode
            if len(val) > 1:
                # Check if more than one sample assigned to barcode without a 3 prime bc
                if all([sample.startswith(":") for sample in val]):
                    print(key)
                    print(val)
                    print("ERROR: More than one sample assigned to 5' barcode without a 3' bc to seperate them")
                    exit(1)

                # Check if more than one sample assigned to barcode but with a mixed assignment of barcodes
                if any([sample.startswith(":") for sample in val]):
                    print(key)
                    print(val)
                    print("ERROR: 3' barcodes: length and position of the non-N nucleotides in the barcodes must be consistent for all 3’ barcodes linked to one specific 5’ barcode.")
                    exit(1)

                # Write to file
                out_f.write(",".join([key] + val) + "\n")
            else:
                if not val[0].startswith(":"):
                    val[0] = "," + val[0]

                out_f.write(key + val[0] + "\n")


if __name__ == "__main__":
    # Allows switching between nextflow templating and standalone python running using arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--process_name", default="!{process_name}")
    parser.add_argument("--samplesheet", default="!{samplesheet}")
    parser.add_argument("--output", default="!{output}")
    args = parser.parse_args()

    main(args.process_name, args.samplesheet, args.output)
