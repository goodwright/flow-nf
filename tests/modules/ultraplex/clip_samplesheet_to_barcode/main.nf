#!/usr/bin/env nextflow

include { CLIP_SAMPLESHEET_TO_BARCODE } from '../../../../modules/flow-nf/ultraplex/clip_samplesheet_to_barcode/main.nf'

workflow test_samplesheettobardcode_two_samples {

    input = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)

    CLIP_SAMPLESHEET_TO_BARCODE ( input )
}
