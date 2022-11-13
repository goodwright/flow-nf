#!/usr/bin/env nextflow

include { CLIPPY } from '../../../modules/goodwright/clippy/main.nf'

workflow test {

    bed = [ [id:'test'], file(params.goodwright_test_data['clip']['crosslinks'], checkIfExists: true) ]
    gtf = file(params.goodwright_test_data['clip']['seg_gtf'], checkIfExists: true)
    fai = file(params.goodwright_test_data['clip']['clippy_fai'], checkIfExists: true)

    CLIPPY (
        bed,
        gtf,
        fai
    )
}
