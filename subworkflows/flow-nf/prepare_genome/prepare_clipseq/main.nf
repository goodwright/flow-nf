//
// Prepare all genome files for running the clipseq analysis pipeline
//

include { CLIPSEQ_FIND_LONGEST_TRANSCRIPT          } from '../../../../modules/flow-nf/clipseq/find_longest_transcript/main.nf'
include { CLIPSEQ_FILTER_GTF                       } from '../../../../modules/flow-nf/clipseq/filter_gtf/main.nf'
include { ICOUNT_SEGMENT as ICOUNT_SEG_GTF         } from '../../../../modules/flow-nf/icount/segment/main.nf'
include { ICOUNT_SEGMENT as ICOUNT_SEG_FILTGTF     } from '../../../../modules/flow-nf/icount/segment/main.nf'
include { PREPARE_REF as PREPARE_PRIMARY_GENOME    } from '../prepare_ref/main.nf'
include { PREPARE_REF as PREPARE_SMRNA_GENOME      } from '../prepare_ref/main.nf'
include { PREPARE_ALINGER as PREPARE_PRIMARY_INDEX } from '../prepare_aligner/main.nf'
include { PREPARE_ALINGER as PREPARE_SMRNA_INDEX   } from '../prepare_aligner/main.nf'

workflow PREPARE_CLIPSEQ {
    take:
    fasta             // channel: [ fasta ]
    smrna_fasta       // channel: [ fasta ]
    gtf               // channel: [ gtf ]
    genome_index_path // channel: [ folder/tar.gz ]
    smrna_index_path  // channel: [ folder/tar.gz ]

    main:
    ch_versions = Channel.empty()

    /*
    * SUBWORKFLOW: Uncompress and prepare main genome files
    */
    PREPARE_PRIMARY_GENOME (
        fasta,
        gtf,
        [],
        []
    )
    ch_fasta       = PREPARE_PRIMARY_GENOME.out.fasta
    ch_fasta_fai   = PREPARE_PRIMARY_GENOME.out.fasta_fai
    ch_gtf         = PREPARE_PRIMARY_GENOME.out.gtf
    ch_chrom_sizes = PREPARE_PRIMARY_GENOME.out.chrom_sizes
    ch_versions    = ch_versions.mix(PREPARE_PRIMARY_GENOME.out.versions)

    /*
    * SUBWORKFLOW: Uncompress and prepare smrna genome files
    */
    PREPARE_SMRNA_GENOME (
        smrna_fasta,
        [],
        [],
        []
    )
    ch_smrna_fasta       = PREPARE_SMRNA_GENOME.out.fasta
    ch_smrna_fasta_fai   = PREPARE_SMRNA_GENOME.out.fasta_fai
    ch_smrna_chrom_sizes = PREPARE_SMRNA_GENOME.out.chrom_sizes
    ch_versions          = ch_versions.mix(PREPARE_SMRNA_GENOME.out.versions)

    /*
    * MODULE: Find the longest transcript from the primary genome
    */
    CLIPSEQ_FIND_LONGEST_TRANSCRIPT (
        ch_gtf
    )
    ch_longest_transcript = CLIPSEQ_FIND_LONGEST_TRANSCRIPT.out.longest_transcript
    ch_versions           = ch_versions.mix(CLIPSEQ_FIND_LONGEST_TRANSCRIPT.out.versions)

    /*
    * MODULE: Filter the GTF file
    */
    CLIPSEQ_FILTER_GTF (
        ch_gtf
    )
    ch_filt_gtf = CLIPSEQ_FILTER_GTF.out.gtf
    ch_versions = ch_versions.mix(CLIPSEQ_FILTER_GTF.out.versions)

    /*
    * SUBWORKFLOW: Prepare STAR index for primary genome
    */
    PREPARE_PRIMARY_INDEX (
        ["star"],
        ch_fasta.map{ it[1] },
        ch_gtf.map{ it[1] },
        [],
        genome_index_path
    )
    ch_genome_index = PREPARE_PRIMARY_INDEX.out.star_index
    ch_versions     = ch_versions.mix(PREPARE_PRIMARY_INDEX.out.versions)

    /*
    * SUBWORKFLOW: Prepare BT2 index for smrna genome
    */
    PREPARE_SMRNA_INDEX (
        ["bowtie2"],
        ch_smrna_fasta,
        [],
        smrna_index_path,
        []
    )
    ch_smrna_index = PREPARE_SMRNA_INDEX.out.bt2_index
    ch_versions    = ch_versions.mix(PREPARE_SMRNA_INDEX.out.versions)

    /*
    * MODULE: Segment GTF file using icount
    */
    ICOUNT_SEG_GTF (
        ch_gtf,
        ch_fasta_fai.map{ it[1] }
    )
    ch_versions    = ch_versions.mix(ICOUNT_SEG_GTF.out.versions)

    emit:
    fasta              = ch_fasta              // channel: [ val(meta), [ fasta ] ]
    fasta_fai          = ch_fasta_fai          // channel: [ val(meta), [ fai ] ]
    gtf                = ch_gtf                // channel: [ val(meta), [ gtf ] ]
    filtered_gtf       = ch_filt_gtf           // channel: [ val(meta), [ gtf ] ]
    chrom_sizes        = ch_chrom_sizes        // channel: [ val(meta), [ txt ] ]
    smrna_fasta        = ch_smrna_fasta        // channel: [ val(meta), [ fasta ] ]
    smrna_fasta_fai    = ch_smrna_fasta_fai    // channel: [ val(meta), [ fai ] ]
    smrna_chrom_sizes  = ch_smrna_chrom_sizes  // channel: [ val(meta), [ txt ] ]
    longest_transcript = ch_longest_transcript // channel: [ val(meta), [ txt ] ]
    versions           = ch_versions           // channel: [ versions.yml ]
}
