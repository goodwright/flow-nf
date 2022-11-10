//
// Filters fastq files for unwanted alignments before aligning to genome and transcriptome using STAR
// BAM alignments are then sorted, indexed and stats are calculated
//

/*
* MODULES
*/
include { BOWTIE2_ALIGN } from '../../../modules/nf-core/bowtie2/align/main.nf'
include { STAR_ALIGN    } from '../../../modules/nf-core/star/align/main.nf'

/*
* SUBWORKFLOWS
*/
include { BAM_SORT_STATS_SAMTOOLS as BAM_SORT_STATS_SAMTOOLS_GENOME     } from '../../nf-core/bam_sort_stats_samtools/main.nf'
include { BAM_SORT_STATS_SAMTOOLS as BAM_SORT_STATS_SAMTOOLS_TRANSCRIPT } from '../../nf-core/bam_sort_stats_samtools/main.nf'

workflow RNA_ALIGN {
    take:
    fastq      // channel: [ val(meta), [ fastq ] ]
    bt2_index  // channel: [ val(meta), [ index ] ]
    star_index // channel: [ index ]
    gtf        // channel: [ gtf ]
    fasta      // channel: [ fasta/fa ]

    main:
    ch_versions = Channel.empty()

    /*
    * MODULE: Align reads to smrna genome
    */
    BOWTIE2_ALIGN (
        fastq,
        bt2_index,
        true,
        false
    )
    ch_versions = ch_versions.mix(BOWTIE2_ALIGN.out.versions)

    /*
    * MODULE: Align reads that did not align to the smrna genome to the primary genome
    */
    STAR_ALIGN (
        BOWTIE2_ALIGN.out.fastq,
        star_index,
        gtf,
        false,
        '',
        ''
    )
    ch_versions = ch_versions.mix(STAR_ALIGN.out.versions)

    /*
    * SUBWORKFLOW: Sort, index, stats on genome-level bam
    */
    BAM_SORT_STATS_SAMTOOLS_GENOME (
        STAR_ALIGN.out.bam,
        fasta
    )
    ch_versions = ch_versions.mix(BAM_SORT_STATS_SAMTOOLS_GENOME.out.versions)

    /*
    * SUBWORKFLOW: Sort, index, stats on transcript-level bam
    */
    BAM_SORT_STATS_SAMTOOLS_TRANSCRIPT (
        STAR_ALIGN.out.bam_transcript,
        fasta
    )

    emit:
    bt2_bam             = BOWTIE2_ALIGN.out.bam                           // channel: [ val(meta), [ bam ] ]
    bt2_log             = BOWTIE2_ALIGN.out.log                           // channel: [ val(meta), [ txt ] ]
    star_bam            = STAR_ALIGN.out.bam                              // channel: [ val(meta), [ bam ] ]
    star_bam_transcript = STAR_ALIGN.out.bam_transcript                   // channel: [ val(meta), [ bam ] ]
    star_log            = STAR_ALIGN.out.log                              // channel: [ val(meta), [ txt ] ]
    star_log_final      = STAR_ALIGN.out.log_final                        // channel: [ val(meta), [ txt ] ]
    genome_bam          = BAM_SORT_STATS_SAMTOOLS_GENOME.out.bam          // channel: [ val(meta), [ bam ] ]
    genome_bai          = BAM_SORT_STATS_SAMTOOLS_GENOME.out.bai          // channel: [ val(meta), [ bai ] ]
    genome_stats        = BAM_SORT_STATS_SAMTOOLS_GENOME.out.stats        // channel: [ val(meta), [ stats ] ]
    genome_flagstat     = BAM_SORT_STATS_SAMTOOLS_GENOME.out.flagstat     // channel: [ val(meta), [ flagstat ] ]
    genome_idxstats     = BAM_SORT_STATS_SAMTOOLS_GENOME.out.idxstats     // channel: [ val(meta), [ idxstats ] ]
    transcript_bam      = BAM_SORT_STATS_SAMTOOLS_TRANSCRIPT.out.bam      // channel: [ val(meta), [ bam ] ]
    transcript_bai      = BAM_SORT_STATS_SAMTOOLS_TRANSCRIPT.out.bai      // channel: [ val(meta), [ bai ] ]
    transcript_stats    = BAM_SORT_STATS_SAMTOOLS_TRANSCRIPT.out.stats    // channel: [ val(meta), [ stats ] ]
    transcript_flagstat = BAM_SORT_STATS_SAMTOOLS_TRANSCRIPT.out.flagstat // channel: [ val(meta), [ flagstat ] ]
    transcript_idxstats = BAM_SORT_STATS_SAMTOOLS_TRANSCRIPT.out.idxstats // channel: [ val(meta), [ idxstats ] ]
    versions            = ch_versions                                     // channel: [ versions.yml ]
}
