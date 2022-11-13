#!/usr/bin/env nextflow

include { PARACLU_PARACLU } from '../../../../modules/goodwright/paraclu/paraclu/main.nf'

workflow test {

    bed = [ [id:'test'], file(params.goodwright_test_data['clip']['paraclu_bed'], checkIfExists: true) ]

    PARACLU_PARACLU (
        bed,
        30
    )
}
