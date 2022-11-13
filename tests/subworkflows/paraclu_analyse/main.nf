#!/usr/bin/env nextflow

include { PARACLU_ANALYSE } from '../../../subworkflows/goodwright/paraclu_analyse/main.nf'

workflow test {

    bed = [ [id:'test'], file(params.goodwright_test_data['clip']['crosslinks'], checkIfExists: true) ]

    PARACLU_ANALYSE ( 
        bed,
        10 
    )
}
