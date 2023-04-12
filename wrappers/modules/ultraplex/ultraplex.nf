#!/usr/bin/env nextflow

include { ULTRAPLEX } from '../../../modules/goodwright/ultraplex/ultraplex/main.nf'

workflow  {

    meta     = [id:file(params.reads).name]
    barcodes = file(params.barcodes, checkIfExists: true)
    fastq    = [ meta, file(params.reads, checkIfExists: true)]

    ULTRAPLEX ( 
        fastq,
        barcodes,
        params.three_prime_adapter
    )
}
