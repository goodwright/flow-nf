#!/usr/bin/env nextflow

include { ICOUNT_PEAKS } from "../../../modules/goodwright/icount/peaks/main"

workflow {

    ch_bed = [ [id:file(params.bed).baseName], file(params.bed, checkIfExists: true), file(params.sigxls, checkIfExists: true)]

    ICOUNT_PEAKS (
        ch_bed
    )

}
