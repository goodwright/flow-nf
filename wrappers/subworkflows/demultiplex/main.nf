#!/usr/bin/env nextflow

include { CLIP_DEMULTIPLEX } from '../../../subworkflows/goodwright/clip_demultiplex/main.nf'

workflow  {
    samplesheet = file(params.samplesheet, checkIfExists: true)
    fastq    = file(params.fastq, checkIfExists: true)

    CLIP_DEMULTIPLEX ( samplesheet, fastq )
}
