#!/usr/bin/env python

import os
import sys
import errno
import argparse
import platform


def make_dir(path):
    if len(path) > 0:
        try:
            os.makedirs(path)
        except OSError as exception:
            if exception.errno != errno.EEXIST:
                raise exception


def print_error(error, context="Line", context_str=""):
    error_str = "ERROR: Please check samplesheet -> {}".format(error)
    if context != "" and context_str != "":
        error_str = "ERROR: Please check samplesheet -> {}\n{}: '{}'".format(
            error, context.strip(), context_str.strip()
        )
    print(error_str)
    sys.exit(1)


def dump_versions(process_name):
    with open("versions.yml", "w") as out_f:
        out_f.write(process_name + ":\n")
        out_f.write("    python: " + platform.python_version() + "\n")


def check_samplesheet(process_name, file_in, file_out):
    """
    This function checks that the samplesheet follows the following structure:

    sample,type,protocol,fastq_1,fastq_2,expected_cells(optional)
    """
    # Dump version file
    dump_versions(process_name)

    # Init
    num_fastq_list = []
    sample_names_list = []
    sample_run_dict = {}

    with open(file_in, "r") as fin:
        ## Check header
        MIN_COLS = 3
        HEADER = ["sample", "type", "protocol", "fastq_1", "fastq_2"]
        header = [x.strip('"') for x in fin.readline().strip().split(",")]
        ACTUAL_HEADER_LEN = len(header)

        ## Check sample entries
        line_no = 1
        for line in fin:
            lspl = [x.strip().strip('"') for x in line.strip().split(",")]

            ## Check if its just a blank line so we dont error
            if line.strip() == "":
                continue

            ## Check valid number of columns per row
            if len(lspl) != ACTUAL_HEADER_LEN:
                print_error(
                    "Invalid number of columns (found {} should be {})! - line no. {}".format(
                        len(lspl), len(HEADER), line_no
                    ),
                    "Line",
                    line,
                )

            ## Check valid number of populated columns per row
            num_cols = len([x for x in lspl if x])
            if num_cols < MIN_COLS:
                print_error(
                    "Invalid number of populated columns (minimum = {})!".format(MIN_COLS),
                    "Line",
                    line,
                )

            ## Check sample name entries
            sample, type, protocol, fastq_1, fastq_2 = lspl[: len(HEADER)]
            if sample:
                if sample.find(" ") != -1:
                    print_error("Sample entry contains spaces!", "Line", line)
            else:
                print_error("Sample entry has not been specified!", "Line", line)

            if sample:
                if sample.find(".") != -1:
                    print_error("Sample entry contains dots!", "Line", line)

            ## Check FastQ file extension
            for fastq in [fastq_1, fastq_2]:
                if fastq:
                    if fastq.find(" ") != -1:
                        print_error("FastQ file contains spaces!", "Line", line)
                    if not fastq.endswith(".fastq.gz") and not fastq.endswith(".fq.gz"):
                        print_error(
                            "FastQ file does not have extension '.fastq.gz' or '.fq.gz'!",
                            "Line",
                            line,
                        )
            num_fastq = len([fastq for fastq in [fastq_1, fastq_2] if fastq])
            num_fastq_list.append(num_fastq)

            ## Auto-detect paired-end/single-end
            sample_info = []
            if sample and fastq_1 and fastq_2:  ## Paired-end short reads
                sample_info = [sample, type, protocol, "0"]
            elif sample and fastq_1 and not fastq_2:  ## Single-end short reads
                sample_info = [sample, type, protocol, "1"]
            else:
                print_error("Invalid combination of columns provided!", "Line", line)

            ## Collect additional sample data
            extra_data = lspl[len(HEADER) :]
            sample_info = sample_info + extra_data

            ## Add fastq 1 and fastq 2
            sample_info = sample_info + [fastq_1, fastq_2]

            ## Create sample mapping dictionary
            if sample not in sample_run_dict:
                sample_run_dict[sample] = [sample_info]
            else:
                sample_run_dict[sample].append(sample_info)

            ## Store unique sample names
            if sample not in sample_names_list:
                sample_names_list.append(sample)

            line_no = line_no + 1

    ## Calculate output header
    output_header = ["sample", "type", "protocol", "single_end"]
    extra_header = header[len(HEADER) :]
    output_header = output_header + extra_header + ["fastq_1", "fastq_2"]

    ## Write validated samplesheet with appropriate columns
    if len(sample_run_dict) > 0:
        out_dir = os.path.dirname(file_out)
        make_dir(out_dir)
        with open(file_out, "w") as fout:
            fout.write(",".join(output_header) + "\n")

            for sample in sorted(sample_run_dict.keys()):
                for sample_info in sample_run_dict[sample]:
                    fout.write(",".join(sample_info) + "\n")


if __name__ == "__main__":
    # Allows switching between nextflow templating and standalone python running using arguments
    parser = argparse.ArgumentParser()
    parser.add_argument("--process_name", default="!{process_name}")
    parser.add_argument("--samplesheet", default="!{samplesheet}")
    parser.add_argument("--output", default="!{output}")
    args = parser.parse_args()

    check_samplesheet(args.process_name, args.samplesheet, args.output)
