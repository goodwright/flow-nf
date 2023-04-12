#!/usr/bin/env nextflow

include { SAMPLESHEET_TO_BARCODE } from '../../../../modules/goodwright/ultraplex/samplesheet_to_barcode/main.nf'

workflow test_samplesheettobarcode_two_samples {

    input = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)

    SAMPLESHEET_TO_BARCODE ( input )
}

workflow test_samplesheettobarcode_adapter_mismatch {

    input = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_adapter_mis'], checkIfExists: true)

    SAMPLESHEET_TO_BARCODE ( input )
}

workflow test_samplesheettobarcode_multisheet {

    input  = file(params.goodwright_test_data['samplesheets']['clip_samplesheet'], checkIfExists: true)
    input2 = file(params.goodwright_test_data['samplesheets']['clip_samplesheet_small'], checkIfExists: true)
    input3 = file(params.goodwright_test_data['samplesheets']['rna_samplesheet'], checkIfExists: true)

    ch_input = Channel.from([input, input2, input3])

    SAMPLESHEET_TO_BARCODE ( ch_input.collect() )
}
