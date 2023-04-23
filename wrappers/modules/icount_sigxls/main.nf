#!/usr/bin/env nextflow

include { ICOUNT_SIGXLS } from "../../../modules/goodwright/icount/sigxls/main"

workflow {

    ch_bed = [ [id:file(params.bed).baseName], file(params.bed, checkIfExists: true) ]
    ch_segmentation = file(params.segmentation, checkIfExists: true)

    ICOUNT_SIGXLS (
        ch_bed,
        ch_segmentation
    )

}
