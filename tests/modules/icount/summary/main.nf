#!/usr/bin/env nextflow

include { ICOUNT_SUMMARY } from '../../../../modules/goodwright/icount/summary/main.nf'
include { GUNZIP         } from '../../../../modules/nf-core/gunzip/main.nf'

workflow test {

    bed    = [ [id:'test'], file(params.goodwright_test_data['clip']['crosslinks'], checkIfExists: true) ]
    gtf_gz = [ [id:'gtf'], file(params.goodwright_test_data['icount']['seg_res_gtf_gz'], checkIfExists: true) ]

    GUNZIP ( gtf_gz )

    ICOUNT_SUMMARY (
        bed,
        GUNZIP.out.gunzip.map{ it[1] }
    )
}
