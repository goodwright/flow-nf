#!/usr/bin/env nextflow

include { ICOUNT_PEAKS } from '../../../../modules/flow-nf/icount/peaks/main.nf'

workflow test {

    bed_sigxls = [ [id:'test'], file(params.goodwright_test_data['clip']['crosslinks'], checkIfExists: true), file(params.goodwright_test_data['icount']['sigxls_gz'], checkIfExists: true) ]
    gtf        = file(params.goodwright_test_data['clip']['seg_gtf'], checkIfExists: true)

    ICOUNT_PEAKS (
        bed_sigxls,
        gtf
    )
}
