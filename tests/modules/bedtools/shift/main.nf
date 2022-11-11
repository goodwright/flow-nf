#!/usr/bin/env nextflow

include { BEDTOOLS_SHIFT as BEDTOOLS_SHIFT_DEFAULT    } from '../../../../modules/flow-nf/bedtools/shift/main.nf'
include { BEDTOOLS_SHIFT as BEDTOOLS_SHIFT_WITHPARAMS } from '../../../../modules/flow-nf/bedtools/shift/main.nf'

workflow test_default {

    bed = [ [id:'test'], file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true) ]
    fai = file(params.test_data['sarscov2']['genome']['genome_fasta_fai'], checkIfExists: true)

    BEDTOOLS_SHIFT_DEFAULT (
        bed,
        fai
    )
}

workflow test_withparams {

    bed = [ [id:'test'], file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true) ]
    fai = file(params.test_data['sarscov2']['genome']['genome_fasta_fai'], checkIfExists: true)

    BEDTOOLS_SHIFT_WITHPARAMS (
        bed,
        fai
    )
}