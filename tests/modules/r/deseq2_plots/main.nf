#!/usr/bin/env nextflow

include { R_DESEQ2_PLOTS } from '../../../../modules/goodwright/r/deseq2_plots/main.nf'

workflow test_basic {

    dds = [ [id:'test'], file(params.goodwright_test_data['deseq2']['rds_condition'], checkIfExists: true) ]

    R_DESEQ2_PLOTS(
        dds,
        "condition",
        "A",
        "B",
        []
    )
}
