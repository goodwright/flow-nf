#!/usr/bin/env nextflow

include { ICOUNT_SEGMENT } from '../../../../modules/goodwright/icount/segment/main.nf'

workflow test_gtf {

    gtf = [ [:], file(params.goodwright_test_data['genome']['gencode35_gtf'], checkIfExists: true) ]
    fai = file(params.test_data['homo_sapiens']['genome']['genome_fasta_fai'], checkIfExists: true)

    ICOUNT_SEGMENT (
        gtf,
        fai
    )
}
