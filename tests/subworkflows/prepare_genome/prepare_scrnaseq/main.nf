#!/usr/bin/env nextflow

include { PREPARE_SCRNASEQ } from '../../../../subworkflows/goodwright/prepare_genome/prepare_scrnaseq/main'

workflow test_compressed {

    fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta_gz'], checkIfExists: true)
    gtf   = file(params.goodwright_test_data['genome']['homosapien_gtf_gz'], checkIfExists: true)

    PREPARE_SCRNASEQ (
        fasta,
        gtf,
        "standard"
    )
}

workflow test_uncompressed {

    fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf   = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)

    PREPARE_SCRNASEQ (
        fasta,
        gtf,
        "standard"
    )
}
