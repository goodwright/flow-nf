#!/usr/bin/env nextflow

include { PREPARE_ALINGER as PREPARE_ALINGER_FASTA  } from '../../../../subworkflows/flow-nf/prepare_genome/prepare_aligner/main.nf'
include { PREPARE_ALINGER as PREPARE_ALINGER_FOLDER } from '../../../../subworkflows/flow-nf/prepare_genome/prepare_aligner/main.nf'

workflow test_fasta {

    fasta = [ [:], file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true) ]
    gtf   = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)

    // Test indexing with fasta file
    PREPARE_ALINGER_FASTA (
        ["bowtie2", "star"],
        fasta,
        gtf,
        [],
        []
    )

    // Pass those indexes through as folders (test data is too large to be kept in repo)
    PREPARE_ALINGER_FOLDER (
        ["bowtie2", "star"],
        fasta,
        gtf,
        PREPARE_ALINGER_FASTA.out.bt2_index.map{ it[1] }.collect(),
        PREPARE_ALINGER_FASTA.out.star_index.map{ it[1] }.collect()
    )
}

workflow test_tar {

    fasta         = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf           = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)
    bowtie2_index = file(params.goodwright_test_data['aligners']['bowtie2_index_tar'], checkIfExists: true)
    star_index    = file(params.goodwright_test_data['aligners']['star_index_tar'], checkIfExists: true)

    PREPARE_ALINGER_FASTA (
        ["bowtie2", "star"],
        fasta,
        gtf,
        bowtie2_index,
        star_index
    )
}

workflow test_nullparams {

    fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf   = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)

    PREPARE_ALINGER_FASTA (
        [],
        fasta,
        gtf,
        [],
        []
    )
}