#!/usr/bin/env nextflow

include { ULTRAPLEX } from '../../../../modules/goodwright/ultraplex/ultraplex/main.nf'

workflow test_ultraplex {

    barcodes = file(params.goodwright_test_data['ultraplex']['barcodes'], checkIfExists: true)
    input = [[id: "test"], file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)]

    ULTRAPLEX ( input, barcodes )
}
