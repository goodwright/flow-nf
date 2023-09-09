#!/usr/bin/env nextflow

include { PREPARE_CLIPSEQ } from '../../../../subworkflows/goodwright/prepare_genome/prepare_clipseq/main.nf'

def checkMetadata(channel, channelName) {
    channel.map { 
        if(!(it[0] instanceof java.util.LinkedHashMap)) { 
            error("No metadata detected in ${channelName}") 
        } 
    }
}

workflow test_noindex {

    fasta       = file(params.goodwright_test_data['genome']['chr21_fasta'], checkIfExists: true)
    smrna_fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf         = file(params.goodwright_test_data['genome']['gencode35_gtf'], checkIfExists: true)

    PREPARE_CLIPSEQ (
        fasta,
        smrna_fasta,
        gtf,
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        []
    )

    def channelMapping = [
        [PREPARE_CLIPSEQ.out.fasta_fai, "fasta_fai"],
        [PREPARE_CLIPSEQ.out.gtf, "gtf"],
        [PREPARE_CLIPSEQ.out.filtered_gtf, "filtered_gtf"],
        [PREPARE_CLIPSEQ.out.chrom_sizes, "chrom_sizes"],
        [PREPARE_CLIPSEQ.out.smrna_fasta, "smrna_fasta"],
        [PREPARE_CLIPSEQ.out.smrna_fasta_fai, "smrna_fasta_fai"],
        [PREPARE_CLIPSEQ.out.smrna_chrom_sizes, "smrna_chrom_sizes"],
        [PREPARE_CLIPSEQ.out.longest_transcript, "longest_transcript"],
        [PREPARE_CLIPSEQ.out.longest_transcript_fai, "longest_transcript_fai"],
        [PREPARE_CLIPSEQ.out.longest_transcript_gtf, "longest_transcript_gtf"],
        [PREPARE_CLIPSEQ.out.seg_gtf, "seg_gtf"],
        [PREPARE_CLIPSEQ.out.seg_filt_gtf, "seg_filt_gtf"],
        [PREPARE_CLIPSEQ.out.seg_resolved_gtf, "seg_resolved_gtf"],
        [PREPARE_CLIPSEQ.out.seg_resolved_gtf_genic, "seg_resolved_gtf_genic"],
        [PREPARE_CLIPSEQ.out.regions_gtf, "regions_gtf"],
        [PREPARE_CLIPSEQ.out.regions_filt_gtf, "regions_filt_gtf"],
        [PREPARE_CLIPSEQ.out.regions_resolved_gtf, "regions_resolved_gtf"],
        [PREPARE_CLIPSEQ.out.regions_resolved_gtf_genic, "regions_resolved_gtf_genic"],
        [PREPARE_CLIPSEQ.out.genome_index, "genome_index"],
        [PREPARE_CLIPSEQ.out.smrna_index, "smrna_index"]
    ]

    // Check we have meta data in all channel outputs
    channelMapping.each { 
        def channelRef = it[0]
        def channelName = it[1]
        checkMetadata(channelRef, channelName) 
    }
}

workflow test_withindex {

    fasta         = file(params.goodwright_test_data['genome']['chr21_fasta'], checkIfExists: true)
    smrna_fasta   = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf           = file(params.goodwright_test_data['genome']['gencode35_gtf'], checkIfExists: true)
    bowtie2_index = file(params.goodwright_test_data['aligners']['bowtie2_index_tar'], checkIfExists: true)
    star_index    = file(params.goodwright_test_data['aligners']['star_index_tar'], checkIfExists: true)

    PREPARE_CLIPSEQ (
        fasta,
        smrna_fasta,
        gtf,
        star_index,
        bowtie2_index,
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        [],
        []
    )

    def channelMapping = [
        [PREPARE_CLIPSEQ.out.fasta_fai, "fasta_fai"],
        [PREPARE_CLIPSEQ.out.gtf, "gtf"],
        [PREPARE_CLIPSEQ.out.filtered_gtf, "filtered_gtf"],
        [PREPARE_CLIPSEQ.out.chrom_sizes, "chrom_sizes"],
        [PREPARE_CLIPSEQ.out.smrna_fasta, "smrna_fasta"],
        [PREPARE_CLIPSEQ.out.smrna_fasta_fai, "smrna_fasta_fai"],
        [PREPARE_CLIPSEQ.out.smrna_chrom_sizes, "smrna_chrom_sizes"],
        [PREPARE_CLIPSEQ.out.longest_transcript, "longest_transcript"],
        [PREPARE_CLIPSEQ.out.longest_transcript_fai, "longest_transcript_fai"],
        [PREPARE_CLIPSEQ.out.longest_transcript_gtf, "longest_transcript_gtf"],
        [PREPARE_CLIPSEQ.out.seg_gtf, "seg_gtf"],
        [PREPARE_CLIPSEQ.out.seg_filt_gtf, "seg_filt_gtf"],
        [PREPARE_CLIPSEQ.out.seg_resolved_gtf, "seg_resolved_gtf"],
        [PREPARE_CLIPSEQ.out.seg_resolved_gtf_genic, "seg_resolved_gtf_genic"],
        [PREPARE_CLIPSEQ.out.regions_gtf, "regions_gtf"],
        [PREPARE_CLIPSEQ.out.regions_filt_gtf, "regions_filt_gtf"],
        [PREPARE_CLIPSEQ.out.regions_resolved_gtf, "regions_resolved_gtf"],
        [PREPARE_CLIPSEQ.out.regions_resolved_gtf_genic, "regions_resolved_gtf_genic"],
        [PREPARE_CLIPSEQ.out.genome_index, "genome_index"],
        [PREPARE_CLIPSEQ.out.smrna_index, "smrna_index"]
    ]

    // Check we have meta data in all channel outputs
    channelMapping.each { 
        def channelRef = it[0]
        def channelName = it[1]
        checkMetadata(channelRef, channelName) 
    }
}
