#!/usr/bin/env nextflow

include { DEMULTIPLEX } from '../../../subworkflows/goodwright/demultiplex/main.nf'

workflow  {
    fastq    = file(params.fastq, checkIfExists: true)

    // Find all samplesheet parameters and build them into a list
    def List files = []
    Set params_key_set = params.keySet()
    params_key_set.each {
       if(it.contains("samplesheet")) {
            files.add(file(params[it], checkIfExists: true))
       }
    }

    // Create channel from list and execute
    ch_samplesheet = Channel.from(files)
    //ch_samplesheet | view

    DEMULTIPLEX ( ch_samplesheet, fastq )
}
