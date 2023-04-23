#!/usr/bin/env nextflow

include { PARACLU_CUT } from "../../../modules/goodwright/paraclu/cut/main"

workflow {

    ch_tsv = [ [id:file(params.tsv).baseName], file(params.tsv, checkIfExists: true) ]

    PARACLU_CUT (
        ch_tsv
    )

}
