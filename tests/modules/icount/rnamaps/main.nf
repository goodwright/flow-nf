#!/usr/bin/env nextflow

include { ICOUNT_RNAMAPS } from '../../../../modules/flow-nf/icount/rnamaps/main.nf'

workflow test {

    bed = [ [id:'test'], file(params.goodwright_test_data['clip']['crosslinks'], checkIfExists: true) ]
    gtf = file(params.goodwright_test_data['clip']['seg_gtf'], checkIfExists: true)

    ICOUNT_RNAMAPS (
        bed,
        gtf
    )
}
