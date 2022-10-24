#!/usr/bin/env nextflow

include { CLIPSEQ_FILTER_GTF } from '../../../../modules/flow-nf/clipseq/filter_gtf/main.nf'

workflow test_gtf_filter {

    gtf = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)

    CLIPSEQ_FILTER_GTF ( gtf )
}
