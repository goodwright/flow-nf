#!/usr/bin/env nextflow

include { PREPARE_REF } from '../../../../subworkflows/flow-nf/prepare_genome/prepare_ref/main.nf'

workflow test_compressed {

    fasta     = file(params.test_data['sarscov2']['genome']['genome_fasta_gz'], checkIfExists: true)
    gtf       = file(params.test_data['sarscov2']['genome']['genome_gff3_gz'], checkIfExists: true)
    bed       = file(params.test_data['sarscov2']['genome']['test_bed_gz'], checkIfExists: true)
    blacklist = file(params.goodwright_test_data['genome']['mm10_blacklist_gz'], checkIfExists: true)

    PREPARE_REF (
        fasta,
        gtf,
        bed,
        blacklist
    )
}

// uncompressed

// non existant
