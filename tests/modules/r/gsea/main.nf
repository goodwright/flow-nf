#!/usr/bin/env nextflow

include { R_GSEA as R_GSEA_BASIC } from '../../../../modules/goodwright/r/gsea/main.nf'
include { R_GSEA as R_GSEA_PARAM } from '../../../../modules/goodwright/r/gsea/main.nf'

workflow test_basic {

    results = [ [id:'test'], file(params.goodwright_test_data['deseq2']['results_2'], checkIfExists: true) ]

    R_GSEA_BASIC(
        results,
        "human"
    )
}

workflow test_param {

    results = [ [id:'test'], file(params.goodwright_test_data['deseq2']['results_2'], checkIfExists: true) ]

    R_GSEA_PARAM(
        results,
        "human"
    )
}
