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

workflow test_channel_samplesheet_multi {

    fastq  = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)
    input  = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)
    input2 = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_small'], checkIfExists: true)
    input3 = file(params.goodwright_test_data['samplesheets']['rna_samplesheet'], checkIfExists: true)

    ch_input = Channel.from([input, input2, input3])

    DEMULTIPLEX ( ch_input, fastq )

    DEMULTIPLEX.out.fastq | view
}

workflow test_channel_samplesheet_multi_mixed {

    fastq  = file(params.goodwright_test_data['ultraplex']['multiplexed_fastq'], checkIfExists: true)
    input  = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_xlsx'], checkIfExists: true)
    input2 = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_small'], checkIfExists: true)
    input3 = file(params.goodwright_test_data['samplesheets']['rna_samplesheet'], checkIfExists: true)

    ch_input = Channel.from([input, input2, input3])

    DEMULTIPLEX ( ch_input, fastq )

    DEMULTIPLEX.out.fastq | view
}
