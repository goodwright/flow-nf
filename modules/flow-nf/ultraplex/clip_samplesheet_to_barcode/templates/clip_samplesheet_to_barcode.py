#!/usr/bin/env python3

"""Convert clip samplesheet into an input that ultraplex can read."""

from sys import exit
from pandas import read_csv

def main():
    # Read CSV file into dataframe
    df_samplesheet = read_csv("!{samplesheet}", dtype=str, keep_default_na=False)

    # Init for loop
    five_prime = df_samplesheet["5' Barcode"]
    three_prime = df_samplesheet["3' Barcode (optional)"]
    sample_names = df_samplesheet["Sample Name"]
    barcode_dict = {}

    # Create barcode dict
    for idx in range(len(five_prime)):
        barcode_dict.setdefault(five_prime[idx], [])
        barcode_dict[five_prime[idx]].append(three_prime[idx] + ":" + sample_names[idx])

    # Write to file with error checking
    with open("!{output}", "w") as out_f:
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
    main()
