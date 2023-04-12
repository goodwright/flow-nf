# Demultiplex

The demultiplex subworkflow is designed to separate multiplexed sequencing data stored in a fastq file into separate files based on a barcoding scheme.

This pipeline is essentially a wrapper around the [Ultraplex](https://github.com/ulelab/ultraplex) where a input samplesheet is processed for input into Ultraplex. Single or paired-end input is accepted as is support for `.csv` or `.xlsx` files.

## Inputs

`samplesheet`

Input `.csv.` or `.xlsx` file detailing each sample to be demultiplexed with its 5' and 3' barcoding scheme. The table must be in the following format:

| id       | 5prime_barcode | 3prime_barcode | 3' Adaptor Sequence  |
| -------- | -------------- | -------------- | -------------------- |
| Sample 1 | NNNGGCGNN      |                | AGATCGGAAGAGCGGTTCAG |
| Sample 2 | NNNTTGTNN      |                | AGATCGGAAGAGCGGTTCAG |
