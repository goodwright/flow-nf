#!/usr/bin/env nextflow

include { XLSX_TO_CSV } from '../../../modules/flow-nf/xlsx_to_csv/main.nf'

workflow test_xlsxtocsv_xlsx {

    input = file(params.goodwright_test_data['excel']['small_xlsx'], checkIfExists: true)

    XLSX_TO_CSV ( input )
}
