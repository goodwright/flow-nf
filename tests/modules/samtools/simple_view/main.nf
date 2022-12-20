#!/usr/bin/env nextflow

include { SAMTOOLS_SIMPLE_VIEW } from '../../../../modules/goodwright/samtools/simple_view/main.nf'

workflow test_simple_view_longest_transcripts {

    longest_transcript = file(params.goodwright_test_data['genome']['longest_transcript'], checkIfExists: true)
    input = [[id: "test"],
             file(params.goodwright_test_data['clip']['bam_2'], checkIfExists: true),
             file(params.goodwright_test_data['clip']['bai_2'], checkIfExists: true) ]


    SAMTOOLS_SIMPLE_VIEW (
        input,
        [],
        longest_transcript
    )
}
