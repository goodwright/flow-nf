//
// Group together crosslinks files and perform downstream analyses
//

/*
* MODULES
*/
include { BEDTOOLS_BAMTOBED                            } from '../../../modules/nf-core/bedtools/bamtobed/main.nf'
include { BEDTOOLS_SHIFT                               } from '../../../modules/goodwright/bedtools/shift/main.nf'
include { BEDTOOLS_GENOMECOV as BEDTOOLS_GENOMECOV_POS } from '../../../modules/nf-core/bedtools/genomecov/main.nf'
include { BEDTOOLS_GENOMECOV as BEDTOOLS_GENOMECOV_NEG } from '../../../modules/nf-core/bedtools/genomecov/main.nf'
include { LINUX_COMMAND as SELECT_BED_POS              } from '../../../modules/goodwright/linux/command/main.nf'
include { LINUX_COMMAND as SELECT_BED_NEG              } from '../../../modules/goodwright/linux/command/main.nf'
include { LINUX_COMMAND as MERGE_AND_SORT              } from '../../../modules/goodwright/linux/command/main.nf'
include { LINUX_COMMAND as CROSSLINK_COVERAGE          } from '../../../modules/goodwright/linux/command/main.nf'
include { LINUX_COMMAND as CROSSLINK_NORMCOVERAGE      } from '../../../modules/goodwright/linux/command/main.nf'

workflow CLIP_CALC_CROSSLINKS {
    take:
    crosslinks // channel: [ val(meta), [ bam ] ]
    fai // channel: [ fai ]

    main:
    ch_versions = Channel.empty()

    CLIP_DOWNSTREAM (
        ch_merged_xlinks
    )
   emit:
   versions
}
