#!/usr/bin/env nextflow

include { UMICOLLAPSE as UMICOLLAPSE_DEFAULT } from '../../../modules/goodwright/umicollapse/main.nf'
include { UMICOLLAPSE as UMICOLLAPSE_SEP } from '../../../modules/goodwright/umicollapse/main.nf'

workflow test_default {

    input = [[id: "test"],
        file(params.goodwright_test_data['umitools']['bam'], checkIfExists: true),
        file(params.goodwright_test_data['umitools']['bai'], checkIfExists: true) ]

    UMICOLLAPSE_DEFAULT ( input )
}

workflow test_sep {

    input = [[id: "test"],
        file(params.goodwright_test_data['umitools']['umi_bam'], checkIfExists: true),
        file(params.goodwright_test_data['umitools']['bai'], checkIfExists: true) ]

    UMICOLLAPSE_SEP ( input )
}
