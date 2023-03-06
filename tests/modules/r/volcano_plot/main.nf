#!/usr/bin/env nextflow

include { R_VOLCANO_PLOT } from '../../../../modules/goodwright/r/volcano_plot/main.nf'

workflow test_basic {

    results = [ [id:'test'], file(params.goodwright_test_data['deseq2']['results_condition'], checkIfExists: true) ]

    R_VOLCANO_PLOT(
        results,
        "condition",
        "A",
        "B",
        [],
        0.1,
        0.5
    )
}
