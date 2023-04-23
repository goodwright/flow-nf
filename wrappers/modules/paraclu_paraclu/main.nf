#!/usr/bin/env nextflow

include { PARACLU_PARACLU } from "../../../modules/goodwright/paraclu/paraclu/main"

workflow {

    ch_bed = [ [id:file(params.bed).baseName], file(params.bed, checkIfExists: true) ]

    PARACLU_PARACLU (
        ch_bed,
        params.min_ue
    )

}
