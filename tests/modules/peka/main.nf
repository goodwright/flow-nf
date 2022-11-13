#!/usr/bin/env nextflow

include { PEKA   } from '../../../modules/flow-nf/peka/main.nf'
include { GUNZIP } from '../../../modules/nf-core/gunzip/main.nf'

workflow test {

    bed_crosslinks = [ [id:'test'], file(params.goodwright_test_data['clip']['crosslinks'], checkIfExists: true) ]
    bed_peaks      = [ [id:'test'], file(params.goodwright_test_data['clip']['clippy_peaks'], checkIfExists: true) ]
    gtf_gz         = [ [id:'gtf'], file(params.goodwright_test_data['icount']['seg_resoth_gtf_gz'], checkIfExists: true) ]
    fasta          = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    fai            = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)

    GUNZIP ( gtf_gz )

    PEKA(
        bed_peaks,
        bed_crosslinks,
        GUNZIP.out.gunzip.map{ it[1] },
        fasta,
        fai
    )
}
