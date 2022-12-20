#!/usr/bin/env nextflow

include { R_PCAEXPLORER } from '../../../../modules/goodwright/r/pcaexplorer/main.nf'

workflow test_basic {

    dds = [ [id:'test'], file(params.goodwright_test_data['deseq2']['rds_condition'], checkIfExists: true) ]

    R_PCAEXPLORER(
        dds,
        "condition",
        "A",
        "B",
        []
    )
}
