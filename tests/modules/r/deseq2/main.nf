#!/usr/bin/env nextflow

include { R_DESEQ2 } from '../../../../modules/goodwright/r/deseq2/main.nf'

workflow test_basic {

    sample = [ [id:'test'], file(params.goodwright_test_data['deseq2']['sample_cond_only'], checkIfExists: true) ]
    counts = file(params.goodwright_test_data['deseq2']['salmon_counts'], checkIfExists: true)

    R_DESEQ2(
        sample,
        counts,
        "condition",
        "A",
        "B",
        []
    )
}
