#!/usr/bin/env nextflow

include { ICOUNT_ANALYSE } from '../../../subworkflows/flow-nf/icount_analyse/main.nf'
include { GUNZIP         } from '../../../modules/nf-core/gunzip/main.nf'

workflow test {

    ch_bed = Channel.from ( [[ [id:'test'], file(params.goodwright_test_data['clip']['crosslinks'], checkIfExists: true) ]] )
    gtf    = file(params.goodwright_test_data['clip']['seg_gtf'], checkIfExists: true)
    gtf_gz = [ [id:'gtf'], file(params.goodwright_test_data['icount']['seg_res_gtf_gz'], checkIfExists: true) ]

    GUNZIP ( gtf_gz )

    ICOUNT_ANALYSE (
        ch_bed,
        gtf,
        GUNZIP.out.gunzip.map{ it[1] }
    )
}