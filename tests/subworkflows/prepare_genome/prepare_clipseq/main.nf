#!/usr/bin/env nextflow

include { PREPARE_CLIPSEQ } from '../../../../subworkflows/goodwright/prepare_genome/prepare_clipseq/main.nf'

workflow test_noindex {

    fasta       = file(params.goodwright_test_data['genome']['chr21_fasta'], checkIfExists: true)
    smrna_fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf         = file(params.goodwright_test_data['genome']['gencode35_gtf'], checkIfExists: true)

    PREPARE_CLIPSEQ (
        fasta,
        smrna_fasta,
        gtf,
        [],
        []
    )
}

workflow test_withindex {

    fasta         = file(params.goodwright_test_data['genome']['chr21_fasta'], checkIfExists: true)
    smrna_fasta   = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf           = file(params.goodwright_test_data['genome']['gencode35_gtf'], checkIfExists: true)
    bowtie2_index = file(params.goodwright_test_data['aligners']['bowtie2_index_tar'], checkIfExists: true)
    star_index    = file(params.goodwright_test_data['aligners']['star_index_tar'], checkIfExists: true)

    PREPARE_CLIPSEQ (
        fasta,
        smrna_fasta,
        gtf,
        star_index,
        bowtie2_index
    )
}
