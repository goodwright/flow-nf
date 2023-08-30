#!/usr/bin/env nextflow

include { PARSE_FASTQ_INPUT } from '../../../subworkflows/goodwright/parse_fastq_input/main.nf'

workflow test_multi_pe {

    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_multi_pe'], checkIfExists: true)

    PARSE_FASTQ_INPUT ( 
        samplesheet
    )
    PARSE_FASTQ_INPUT.out.fastq | view
}

workflow test_extra_header {

    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_header_exta'], checkIfExists: true)

    PARSE_FASTQ_INPUT ( 
        samplesheet
    )
    PARSE_FASTQ_INPUT.out.fastq | view
}

workflow test_merge_rep {

    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_merge_rep'], checkIfExists: true)

    PARSE_FASTQ_INPUT ( 
        samplesheet
    )
    PARSE_FASTQ_INPUT.out.fastq | view
}
