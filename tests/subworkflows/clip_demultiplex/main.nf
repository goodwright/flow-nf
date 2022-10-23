#!/usr/bin/env nextflow

include { CLIP_DEMULTIPLEX } from '../../../subworkflows/flow-nf/clip_demultiplex/main.nf'

workflow test_single_sample {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_small'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    CLIP_DEMULTIPLEX ( samplesheet, fastq )
}

workflow test_multi_sample {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    CLIP_DEMULTIPLEX ( samplesheet, fastq )
}

workflow test_with_excel {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_xlsx'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    CLIP_DEMULTIPLEX ( samplesheet, fastq )
}