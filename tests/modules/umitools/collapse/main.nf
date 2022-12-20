#!/usr/bin/env nextflow

include { UMITOOLS_COLLAPSE as UMITOOLS_COLLAPSE_DEFAULT } from '../../../../modules/goodwright/umitools/collapse/main.nf'
include { UMITOOLS_COLLAPSE as UMITOOLS_COLLAPSE_SEP } from '../../../../modules/goodwright/umitools/collapse/main.nf'

workflow test_default {

    input = [[id: "test"],
        file(params.goodwright_test_data['umitools']['bam'], checkIfExists: true),
        file(params.goodwright_test_data['umitools']['bai'], checkIfExists: true) ]

    UMITOOLS_COLLAPSE_DEFAULT ( input )
}

workflow test_sep {

    input = [[id: "test"],
        file(params.goodwright_test_data['umitools']['umi_bam'], checkIfExists: true),
        file(params.goodwright_test_data['umitools']['bai'], checkIfExists: true) ]

    UMITOOLS_COLLAPSE_SEP ( input )
}
