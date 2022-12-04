#!/usr/bin/env nextflow

include { RNA_ALIGN           } from '../../../subworkflows/goodwright/rna_align/main.nf'
include { UNTAR as UNTAR_BT1  } from '../../../modules/nf-core/untar/main'
include { UNTAR as UNTAR_STAR } from '../../../modules/nf-core/untar/main'

workflow test_single_end {

    ch_fastq = Channel.fromList(
        [ [[id:"sample_1", single_end:true], [file(params.test_data['homo_sapiens']['illumina']['test_rnaseq_1_fastq_gz'], checkIfExists: true)]] ])

    bowtie1_index_path = file(params.goodwright_test_data['aligners']['hs_smallrna_bowtie1_index_tar'], checkIfExists: true)
    star_index_path    = file(params.goodwright_test_data['aligners']['star_index_tar'], checkIfExists: true)
    gtf                = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)
    fasta              = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)

    ch_bt2_index  = UNTAR_BT1  ( [ [:], bowtie1_index_path ] ).untar
    ch_star_index = UNTAR_STAR ( [ [:], star_index_path ] ).untar

    RNA_ALIGN ( 
        ch_fastq,
        ch_bt2_index,
        ch_star_index.collect{it[1]},
        gtf,
        fasta
    )
}

workflow test_paired_end {

    ch_fastq = Channel.fromList(
        [ [[id:"sample_1", single_end:false], [file(params.test_data['homo_sapiens']['illumina']['test_rnaseq_1_fastq_gz'], checkIfExists: true), 
                                               file(params.test_data['homo_sapiens']['illumina']['test_rnaseq_2_fastq_gz'], checkIfExists: true)]] ])

    bowtie2_index_path = file(params.goodwright_test_data['aligners']['hs_smallrna_bowtie1_index_tar'], checkIfExists: true)
    star_index_path    = file(params.goodwright_test_data['aligners']['star_index_tar'], checkIfExists: true)
    gtf                = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)
    fasta              = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)

    ch_bt2_index  = UNTAR_BT1  ( [ [:], bowtie2_index_path ] ).untar
    ch_star_index = UNTAR_STAR ( [ [:], star_index_path ] ).untar

    RNA_ALIGN ( 
        ch_fastq,
        ch_bt2_index,
        ch_star_index.collect{it[1]},
        gtf,
        fasta
    )
}
