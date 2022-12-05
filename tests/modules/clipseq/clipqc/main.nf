#!/usr/bin/env nextflow

include { CLIPSEQ_CLIPQC } from '../../../../modules/goodwright/clipseq/clipqc/main.nf'

workflow test {

    qc_bt_log        = file(params.goodwright_test_data['clipqc']['premap'], checkIfExists: true)
    qc_star_log      = file(params.goodwright_test_data['clipqc']['mapped'], checkIfExists: true)
    qc_umi_log       = file(params.goodwright_test_data['clipqc']['collapse'], checkIfExists: true)
    qc_crosslinks    = file(params.goodwright_test_data['clipqc']['xlinks'], checkIfExists: true)
    qc_icount_peaks  = file(params.goodwright_test_data['clipqc']['icount'], checkIfExists: true)
    qc_clippy_peaks  = file(params.goodwright_test_data['clipqc']['paraclu'], checkIfExists: true)
    qc_paraclu_peaks = file(params.goodwright_test_data['clipqc']['clippy'], checkIfExists: true)

     CLIPSEQ_CLIPQC (
        qc_bt_log,
        qc_star_log,
        qc_umi_log,
        qc_crosslinks,
        qc_icount_peaks,
        qc_paraclu_peaks,
        qc_clippy_peaks
    )
}
