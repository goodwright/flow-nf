#!/usr/bin/env nextflow

include { PARSE_SCMULTIOME_INPUT } from '../../../subworkflows/goodwright/parse_scmultiome_input/main'

workflow test_multi_pe {

    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_valid_multirep_pe'], checkIfExists: true)

    PARSE_SCMULTIOME_INPUT (
        samplesheet,
        false
    )
    PARSE_SCMULTIOME_INPUT.out.fastq | view
}

workflow test_multi_pe_merge_true {

    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_valid_multirep_pe'], checkIfExists: true)

    PARSE_SCMULTIOME_INPUT (
        samplesheet,
        true
    )
    PARSE_SCMULTIOME_INPUT.out.fastq | view
}

workflow test_merge_rep {

    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_valid_merge_rep'], checkIfExists: true)

    PARSE_SCMULTIOME_INPUT ( 
        samplesheet,
        true
    )
    PARSE_SCMULTIOME_INPUT.out.fastq | view
}
