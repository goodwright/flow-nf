#!/usr/bin/env nextflow

include { ICOUNT_RNAMAPS } from "../../../modules/goodwright/icount/rnamaps/main"

workflow {

    ch_bed = [ [id:file(params.bed).baseName], file(params.bed, checkIfExists: true) ]
    ch_segmentation = file(params.segmentation, checkIfExists: true)

    ICOUNT_RNAMAPS (
        ch_bed,
        ch_segmentation
    )

}
