#!/usr/bin/env nextflow

include { SAMPLESHEET_TO_BARCODE } from '../../../../modules/goodwright/ultraplex/samplesheet_to_barcode/main.nf'

workflow test_samplesheettobardcode_two_samples {

    input = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)

    SAMPLESHEET_TO_BARCODE ( input )
}

workflow test_samplesheettobardcode_adapter_mismatch {

    input = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_adapter_mis'], checkIfExists: true)

    SAMPLESHEET_TO_BARCODE ( input )
}
