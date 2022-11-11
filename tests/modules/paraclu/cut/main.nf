#!/usr/bin/env nextflow

include { PARACLU_CUT } from '../../../../modules/flow-nf/paraclu/cut/main.nf'

workflow test {

    tsv = [ [id:'test'], file(params.goodwright_test_data['clip']['paraclu_tsv'], checkIfExists: true) ]

    PARACLU_CUT( tsv )
}
