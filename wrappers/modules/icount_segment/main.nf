#!/usr/bin/env nextflow

nextflow.enable.dsl=2

include { ICOUNT_SEGMENT } from '../../../modules/goodwright/icount/segment/main'

workflow {

    ch_gtf = [ [id:file(params.gtf).baseName], file(params.gtf, checkIfExists: true) ]
    ch_fai = file(params.fai, checkIfExists: true)

    ICOUNT_SEGMENT ( ch_gtf, ch_fai )
}
