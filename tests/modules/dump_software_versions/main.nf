#!/usr/bin/env nextflow

include { PREPARE_CLIPSEQ        } from '../../../subworkflows/goodwright/prepare_genome/prepare_clipseq/main.nf'
include { DUMP_SOFTWARE_VERSIONS } from '../../../modules/goodwright/dump_software_versions/main.nf'

workflow test {

    fasta       = file(params.goodwright_test_data['genome']['chr21_fasta'], checkIfExists: true)
    smrna_fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf         = file(params.goodwright_test_data['genome']['gencode35_gtf'], checkIfExists: true)

    PREPARE_CLIPSEQ (
        fasta,
        smrna_fasta,
        gtf,
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        []
    )

    DUMP_SOFTWARE_VERSIONS (
        PREPARE_CLIPSEQ.out.versions.unique().collectFile()
    )
}

