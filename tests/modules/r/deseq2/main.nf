#!/usr/bin/env nextflow

include { R_DESEQ2 as R_DESEQ2_NOCONFIG } from '../../../../modules/goodwright/r/deseq2/main.nf'
include { R_DESEQ2 as R_DESEQ2_CONFIG   } from '../../../../modules/goodwright/r/deseq2/main.nf'

workflow test_basic {

    sample = [ [id:'test'], file(params.goodwright_test_data['deseq2']['sample_cond_only'], checkIfExists: true) ]
    counts = file(params.goodwright_test_data['deseq2']['salmon_counts'], checkIfExists: true)

    R_DESEQ2_NOCONFIG(
        sample,
        counts,
        "condition",
        "A",
        "B",
        []
    )
}

workflow test_multi_factor {

    sample = [ [id:'test'], file(params.goodwright_test_data['deseq2']['sample_multi_factor'], checkIfExists: true) ]
    counts = file(params.goodwright_test_data['deseq2']['salmon_counts'], checkIfExists: true)

    R_DESEQ2_NOCONFIG(
        sample,
        counts,
        "condition",
        "A",
        "B",
        "method"
    )
}

workflow test_multi_factor_with_config {

    sample = [ [id:'test'], file(params.goodwright_test_data['deseq2']['sample_multi_factor'], checkIfExists: true) ]
    counts = file(params.goodwright_test_data['deseq2']['salmon_counts'], checkIfExists: true)

    R_DESEQ2_CONFIG(
        sample,
        counts,
        "condition",
        "A",
        "B",
        "method"
    )
}
