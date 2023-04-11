//
// Convert a CLIP samplesheet into a suitable input for ultraplex and then run the demultiplex operation
// Support for users submitting an xlsx file instead of csv
//

include { XLSX_TO_CSV            } from '../../../modules/goodwright/xlsx_to_csv/main'
include { SAMPLESHEET_TO_BARCODE } from '../../../modules/goodwright/ultraplex/samplesheet_to_barcode/main'
include { ULTRAPLEX              } from '../../../modules/goodwright/ultraplex/ultraplex/main'

workflow DEMULTIPLEX {
    take:
    samplesheet // channel: [ [csv/xlsx] ]
    fastq       // channel: [ fastq ]

    main:
    ch_versions = Channel.empty()

    // Convert xlsx to csv if required
    ch_csv = Channel.from( samplesheet )
    if (samplesheet.toString().endsWith(".xlsx")) {
        /*
        * MODULE: Converts xlsx to csv
        */
        XLSX_TO_CSV (
            ch_csv
        )
        ch_versions = ch_versions.mix(XLSX_TO_CSV.out.versions)
        ch_csv      = XLSX_TO_CSV.out.csv
    }

    /*
    * MODULE: Convert the clip samplesheet into ultraplex input
    */
    SAMPLESHEET_TO_BARCODE (
        ch_csv
    )
    ch_versions = ch_versions.mix(SAMPLESHEET_TO_BARCODE.out.versions)

    /*
    * CHANNEL: Pull out params for ultraplex
    */
    SAMPLESHEET_CHECK.out.csv
        .splitCsv ( header:true, sep:"," )
        .map { get_samplesheet_paths(it) }

    /*
    * MODULE: Demultiplex the fastq file
    */
    ULTRAPLEX (
        [ [ id:"fastq" ], fastq ],
        SAMPLESHEET_TO_BARCODE.out.csv
    )
    ch_versions = ch_versions.mix(ULTRAPLEX.out.versions)
    //ULTRAPLEX.out.fastq | view

    /*
    * CHANNEL: Create meta data using the samplesheet and the outputs from ultraplex
    */
    ch_meta_fastq = ch_csv
        .splitCsv (header:true, sep:",")
        .combine (ULTRAPLEX.out.fastq)
        .map { row ->
            def match = []
            row[2].each { file -> if (file.name.contains(row[0].id)) { match << file } }
            [ row[0].id, row[0], match ]
        }
        .unique()
    //ch_meta_fastq | view

    emit:
    fastq    = ch_meta_fastq  // channel: [ val(meta), [ fastq ] ]
    versions = ch_versions    // channel: [ versions.yml ]
}
