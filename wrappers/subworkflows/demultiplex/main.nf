#!/usr/bin/env nextflow

include { DEMULTIPLEX } from '../../../subworkflows/goodwright/demultiplex/main.nf'

workflow  {

    // Find all samplesheet parameters and build them into a list
    def List samplesheet_files = []
    Set params_key_set = params.keySet()
    params_key_set.each {
       if(it.contains("samplesheet")) {
            samplesheet_files.add(file(params[it], checkIfExists: true))
       }
    }

    // Create channel from list
    ch_samplesheet = Channel.from(samplesheet_files)

    // Build fastq file list
    fastqs = file(params.fastq, checkIfExists: true)
    if(params.fastq2) {
        fastq2 = file(params.fastq2, checkIfExists: true)
        fastqs = [fastqs, fastq2]
    }

    // Execute
    DEMULTIPLEX ( ch_samplesheet, fastqs )
}
