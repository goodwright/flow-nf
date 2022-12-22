#!/usr/bin/env nextflow

include { CLIP_DEMULTIPLEX } from '../../../subworkflows/goodwright/clip_demultiplex/main.nf'

workflow test_single_sample {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_small'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    CLIP_DEMULTIPLEX ( samplesheet, fastq )

    CLIP_DEMULTIPLEX.out.fastq | view
}

workflow test_multi_sample {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    CLIP_DEMULTIPLEX ( samplesheet, fastq )

    CLIP_DEMULTIPLEX.out.fastq | view
}

workflow test_with_excel {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_xlsx'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    CLIP_DEMULTIPLEX ( samplesheet, fastq )

    CLIP_DEMULTIPLEX.out.fastq | view
}

workflow test_multi_sample_paired_end {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)
    fastq1      = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)
    fastq2      = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq2'], checkIfExists: true)

    CLIP_DEMULTIPLEX ( samplesheet, [fastq1, fastq2] )

    CLIP_DEMULTIPLEX.out.fastq | view
}
