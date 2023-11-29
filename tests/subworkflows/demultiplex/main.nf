#!/usr/bin/env nextflow

include { DEMULTIPLEX } from '../../../subworkflows/goodwright/demultiplex/main.nf'

workflow test_single_sample {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_small'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    DEMULTIPLEX ( samplesheet, fastq )
    DEMULTIPLEX.out.fastq | view
}

workflow test_multi_sample {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    DEMULTIPLEX ( samplesheet, fastq )
    DEMULTIPLEX.out.fastq | view
}

workflow test_with_excel {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_xlsx'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    DEMULTIPLEX ( samplesheet, fastq )
    DEMULTIPLEX.out.fastq | view
}

workflow test_multi_sample_paired_end {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)
    fastq1      = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)
    fastq2      = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq2'], checkIfExists: true)

    DEMULTIPLEX ( samplesheet, [fastq1, fastq2] )
    DEMULTIPLEX.out.fastq | view
}

workflow test_multi_sample_multi_paired_end {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)
    fastq1      = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)
    fastq2      = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq2'], checkIfExists: true)
    fastq3      = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq3'], checkIfExists: true)
    fastq4      = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq4'], checkIfExists: true)

    ch_fastqs = Channel.from([[fastq1, fastq2], [fastq3, fastq4]])

    DEMULTIPLEX ( samplesheet, ch_fastqs )
    DEMULTIPLEX.out.fastq | view
}

workflow test_adapter_mismatch {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_adapter_mis'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    DEMULTIPLEX ( samplesheet, fastq )
    DEMULTIPLEX.out.fastq | view
}

workflow test_channel_samplesheet {

    samplesheet = Channel.from(file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true))
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    DEMULTIPLEX ( samplesheet, fastq )
    DEMULTIPLEX.out.fastq | view
}

workflow test_threeprimebarcode_only {

    samplesheet = file(params.goodwright_test_data['samplesheets']['clip_3bc_only'], checkIfExists: true)
    fastq       = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)

    DEMULTIPLEX ( samplesheet, fastq )
    DEMULTIPLEX.out.fastq | view
}
