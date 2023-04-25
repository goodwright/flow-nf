#!/usr/bin/env nextflow

include { CLIPPY } from "../../../modules/goodwright/clippy/main"

workflow {

    ch_bed = [ [id:file(params.bed).baseName], file(params.bed, checkIfExists: true) ]
    ch_gtf = file(params.gtf, checkIfExists: true)
    ch_fai = file(params.fai, checkIfExists: true)

    CLIPPY (
        ch_bed,
        ch_gtf,
        ch_fai
    )

}
