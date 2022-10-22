#!/usr/bin/env nextflow

include { CLIP_DEMULTIPLEX } from '../../../subworkflows/flow-nf/clip_demultiplex/main.nf'

// workflow test_single_sample {

//     barcodes = file(params.goodwright_test_data['ultraplex']['barcodes'], checkIfExists: true)
//     input = [[id: "test"], file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)]

//     ULTRAPLEX ( input, barcodes )
// }

workflow test_multi_sample {

    samplesheet = params.goodwright_test_data['samplesheets']['clip_samplesheet']
    fastq       = params.goodwright_test_data['ultraplex']['multiplexed_fastq']

    CLIP_DEMULTIPLEX ( samplesheet, fastq )
}

// workflow test_with_excel {

//     samplesheet = params.goodwright_test_data['samplesheets']['clip_samplesheet']
//     fastq       = params.goodwright_test_data['ultraplex']['multiplexed_fastq']

//     CLIP_DEMULTIPLEX ( samplesheet, fastq )
// }