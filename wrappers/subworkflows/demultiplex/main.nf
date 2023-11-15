#!/usr/bin/env nextflow

include { DEMULTIPLEX } from '../../../subworkflows/goodwright/demultiplex/main.nf'

workflow  {

    // Create channels from input files
    ch_samplesheet = file(params.samplesheet, checkIfExists: true)
    fastqs         = Channel.of(file(params.fastqs, checkIfExists: true))

    // Get list of files from fastqs
    ch_fastqs = fastqs
        .splitCsv(sep:",")
        .map { list ->
            list.collect { file(it, checkIfExists: true) }
        }
    //ch_fastqs | view

    // Execute
    DEMULTIPLEX ( ch_samplesheet, ch_fastqs )
    //DEMULTIPLEX.out.fastq | view
}
