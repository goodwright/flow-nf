#!/usr/bin/env nextflow

include { BAM_DEDUP_STATS_SAMTOOLS_UMITOOLS } from '../../../subworkflows/goodwright/bam_dedup_stats_samtools_umitools/main.nf'

workflow test {

    input = [[id: "test"],
        file(params.goodwright_test_data['umitools']['bam'], checkIfExists: true),
        file(params.goodwright_test_data['umitools']['bai'], checkIfExists: true) ]

    BAM_DEDUP_STATS_SAMTOOLS_UMITOOLS ( 
        input
    )
}
