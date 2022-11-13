#!/usr/bin/env nextflow

include { CLIPSEQ_FIND_LONGEST_TRANSCRIPT } from '../../../../modules/goodwright/clipseq/find_longest_transcript/main.nf'

workflow test_gtf {

    gtf = [ [:], file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true) ]

    CLIPSEQ_FIND_LONGEST_TRANSCRIPT ( gtf )
}
