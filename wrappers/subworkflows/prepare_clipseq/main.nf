#!/usr/bin/env nextflow

include { PREPARE_CLIPSEQ } from '../../../subworkflows/goodwright/prepare_genome/prepare_clipseq/main.nf'

workflow  {
    fasta         = file(params.fasta, checkIfExists: true)
    smrna_fasta   = file(params.smrna_fasta, checkIfExists: true)
    gtf           = file(params.gtf, checkIfExists: true)

    star_index                      = params.star_index ? file(params.star_index, checkIfExists: true) : null
    bowtie2_index                   = params.bowtie2_index ? file(params.bowtie2_index, checkIfExists: true) : null
    fasta_fai                       = params.fasta_fai ? file(params.fasta_fai, checkIfExists: true) : null
    filtered_gtf                    = params.filtered_gtf ? file(params.filtered_gtf, checkIfExists: true) : null
    chrom_sizes                     = params.chrom_sizes ? file(params.chrom_sizes, checkIfExists: true) : null                    
    smrna_fasta_fai                 = params.smrna_fasta_fai ? file(params.smrna_fasta_fai, checkIfExists: true) : null                        
    smrna_chrom_sizes               = params.smrna_chrom_sizes ? file(params.smrna_chrom_sizes, checkIfExists: true) : null                          
    longest_transcript              = params.longest_transcript ? file(params.longest_transcript, checkIfExists: true) : null                           
    longest_transcript_fai          = params.longest_transcript_fai ? file(params.longest_transcript_fai, checkIfExists: true) : null
    longest_transcript_gtf          = params.longest_transcript_gtf ? file(params.longest_transcript_gtf, checkIfExists: true) : null                              
    seg_gtf                         = params.seg_gtf ? file(params.seg_gtf, checkIfExists: true) : null                
    seg_filt_gtf                    = params.seg_filt_gtf ? file(params.seg_filt_gtf, checkIfExists: true) : null                     
    seg_resolved_gtf                = params.seg_resolved_gtf ? file(params.seg_resolved_gtf, checkIfExists: true) : null                         
    seg_resolved_gtf_genic          = params.seg_resolved_gtf_genic ? file(params.seg_resolved_gtf_genic, checkIfExists: true) : null                               
    regions_gtf                     = params.regions_gtf ? file(params.regions_gtf, checkIfExists: true) : null                    
    regions_filt_gtf                = params.regions_filt_gtf ? file(params.regions_filt_gtf, checkIfExists: true) : null                         
    regions_resolved_gtf            = params.regions_resolved_gtf ? file(regions_resolved_gtf, checkIfExists: true) : null                             
    regions_resolved_gtf_genic      = params.regions_resolved_gtf_genic ? file(params.regions_resolved_gtf_genic, checkIfExists: true) : null 

    PREPARE_CLIPSEQ (
        fasta,
        smrna_fasta,
        gtf,
        star_index,
        bowtie2_index,
        fasta_fai,
        filtered_gtf,
        chrom_sizes,
        smrna_fasta_fai,
        smrna_chrom_sizes,
        longest_transcript,
        seg_gtf,
        seg_filt_gtf,
        seg_resolved_gtf,
        seg_resolved_gtf_genic,
        regions_gtf,
        regions_filt_gtf,
        regions_resolved_gtf,
        regions_resolved_gtf_genic,
        longest_transcript_fai,
        longest_transcript_gtf
    )
}
