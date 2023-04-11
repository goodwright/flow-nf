#!/usr/bin/env nextflow

include { DEMULTIPLEX } from '../../../subworkflows/goodwright/demultiplex/main.nf'

workflow  {
    samplesheet = file(params.samplesheet, checkIfExists: true)
    fastq    = file(params.fastq, checkIfExists: true)

    DEMULTIPLEX ( samplesheet, fastq )
}
