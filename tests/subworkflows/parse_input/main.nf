#!/usr/bin/env nextflow

include { PARSE_INPUT } from '../../../subworkflows/goodwright/parse_input/main.nf'

workflow test_multi_pe {

    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_multi_pe'], checkIfExists: true)

    PARSE_INPUT ( 
        samplesheet
    )
    PARSE_INPUT.out.reads | view
}

workflow test_extra_header {

    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_header_exta'], checkIfExists: true)

    PARSE_INPUT ( 
        samplesheet
    )
    PARSE_INPUT.out.reads | view
}
