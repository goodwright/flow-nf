#!/usr/bin/env nextflow

include { BEDTOOLS_SHIFT } from "../../../modules/goodwright/bedtools/shift/main"

workflow {

    ch_bed = [ [id:file(params.bed).baseName], file(params.bed, checkIfExists: true) ]
    ch_fai = file(params.fai, checkIfExists: true)

    BEDTOOLS_SHIFT (
        ch_bed,
        ch_fai
    )

}
