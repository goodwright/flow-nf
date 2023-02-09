//
// Group together crosslinks files and perform downstream analyses
//

/*
* MODULES
*/
include { BEDTOOLS_BAMTOBED                            } from '../../../modules/nf-core/bedtools/bamtobed/main.nf'
include { BEDTOOLS_SHIFT                               } from '../../../modules/goodwright/bedtools/shift/main.nf'


workflow CLIP_CALC_CROSSLINKS {
    take:
    bam // channel: [ val(meta), [ bam ] ]
    fai // channel: [ fai ]

    main:
    ch_versions = Channel.empty()

        /*
        * MODULE: Run clippy on genome-level crosslinks
        */
        CLIPPY (
            ch_genome_crosslink_bed,
            ch_filtered_gtf.collect{ it[1] },
            ch_fasta_fai.collect{ it[1] }
        )
        ch_versions = ch_versions.mix(CLIPPY.out.versions)

        /*
        * SUBWORKFLOW: Run paraclu on genome-level crosslinks
        */
        PARACLU_ANALYSE (
            ch_genome_crosslink_bed,
            params.paraclu_min_value
        )
        ch_versions = ch_versions.mix(PARACLU_ANALYSE.out.versions)

        /*
        * SUBWORKFLOW: Run iCount on genome-level crosslinks
        */
        ICOUNT_ANALYSE (
            ch_genome_crosslink_bed,
            ch_seg_gtf.collect{ it[1] },
            ch_seg_resolved_gtf,
            true
        )
        ch_versions = ch_versions.mix(ICOUNT_ANALYSE.out.versions)

        // /*
        // * MODULE: Run peka on genome-level crosslinks
        // */
        PEKA (
            CLIPPY.out.peaks,
            ch_genome_crosslink_bed,
            ch_fasta.collect{ it[1] },
            ch_fasta_fai.collect{ it[1] },
            ch_regions_resolved_gtf
        )
        ch_versions = ch_versions.mix(PEKA.out.versions)


    emit:
    paraclu_peaks           = MERGE_AND_SORT.out.file         // channel: [ val(meta), [ bed ] ]
    icount_peaks
    icount_rnamap
    icount_summary
    clippy_peaks
    peka
    versions      = ch_versions                     // channel: [ versions.yml ]
}
