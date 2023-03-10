#!/usr/bin/env nextflow

include { R_GSEA } from '../../../../modules/goodwright/r/gsea/main.nf'

workflow test_basic {

    results = [ [id:'test'], file(params.goodwright_test_data['deseq2']['results_2'], checkIfExists: true) ]

    R_GSEA(
        results,
        "human"
    )
}
