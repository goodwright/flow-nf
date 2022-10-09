#!/usr/bin/env nextflow

include { CLIP_SAMPLESHEET_TO_BARCODE } from '../../../../../modules/flow-nf/ultraplex/clip_samplesheet_to_barcode/main.nf'

workflow test_samplesheettobardcode_two_samples {
    
    input = file(params.test_data['sarscov2']['illumina']['test_single_end_bam'], checkIfExists: true)

    CLIP_SAMPLESHEET_TO_BARCODE ( input )
}
