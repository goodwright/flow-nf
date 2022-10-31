#!/usr/bin/env nextflow

include { CLIPSEQ_RESOLVE_UNANNOTATED } from '../../../../modules/flow-nf/clipseq/resolve_unannotated/main.nf'

workflow test_genic_false {

    gtf      = file(params.goodwright_test_data['genome']['gencode35_gtf'], checkIfExists: true)
    seg      = file(params.goodwright_test_data['icount']['segmented_gtf'], checkIfExists: true)
    filt_seg = file(params.goodwright_test_data['icount']['segmented_filtered_gtf'], checkIfExists: true)
    fai      = file(params.goodwright_test_data['genome']['chr21_fai'], checkIfExists: true)

    CLIPSEQ_RESOLVE_UNANNOTATED (
        seg,
        filt_seg,
        gtf,
        fai,
        false
    )
}

workflow test_genic_true {

    gtf      = file(params.goodwright_test_data['genome']['gencode35_gtf'], checkIfExists: true)
    seg      = file(params.goodwright_test_data['icount']['segmented_gtf'], checkIfExists: true)
    filt_seg = file(params.goodwright_test_data['icount']['segmented_filtered_gtf'], checkIfExists: true)
    fai      = file(params.goodwright_test_data['genome']['chr21_fai'], checkIfExists: true)

    CLIPSEQ_RESOLVE_UNANNOTATED (
        seg,
        filt_seg,
        gtf,
        fai,
        true
    )
}
