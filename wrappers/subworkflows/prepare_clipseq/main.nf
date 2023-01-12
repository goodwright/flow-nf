#!/usr/bin/env nextflow

include { PREPARE_CLIPSEQ } from '../../../subworkflows/goodwright/prepare_genome/prepare_clipseq/main.nf'

workflow  {
    fasta         = file(params.fasta, checkIfExists: true)
    smrna_fasta   = file(params.smrna_fasta, checkIfExists: true)
    gtf           = file(params.gtf, checkIfExists: true)

    bowtie2_index = params.star_index ? file(params.star_index, checkIfExists: true) : null
    star_index    = params.bowtie2_index ? file(params.bowtie2_index, checkIfExists: true) : null

    PREPARE_CLIPSEQ (
        fasta,
        smrna_fasta,
        gtf,
        star_index,
        bowtie2_index
    )
}
