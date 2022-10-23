//
// Uncompresses and prepare genome reference files
//

include { XLSX_TO_CSV                 } from '../../../modules/flow-nf/xlsx_to_csv/main'
include { CLIP_SAMPLESHEET_TO_BARCODE } from '../../../modules/flow-nf/ultraplex/clip_samplesheet_to_barcode/main'
include { ULTRAPLEX                   } from '../../../modules/flow-nf/ultraplex/ultraplex/main'

workflow CLIP_DEMULTIPLEX {
    take:
    samplesheet // channel: [ [csv/xlsx] ]
    fastq       // channel: [ fastq ]

    main:
    ch_versions = Channel.empty()



    emit:
    // fastq    = ch_meta_fastq  // channel: [ val(meta), [ fastq ] ]
    versions = ch_versions    // channel: [ versions.yml ]
}