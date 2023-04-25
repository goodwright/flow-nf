#!/usr/bin/env nextflow

include { ICOUNT_SUMMARY } from "../../../modules/goodwright/icount/summary/main"

workflow {

    ch_bed = [ [id:file(params.bed).baseName], file(params.bed, checkIfExists: true) ]
    ch_segmentation = file(params.segmentation, checkIfExists: true)

    ICOUNT_SUMMARY (
        ch_bed,
        ch_segmentation
    )

}
