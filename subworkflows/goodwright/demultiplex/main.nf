//
// Convert a goodwright samplesheet into a suitable input for ultraplex and then run the demultiplex operation
// Support for users submitting an xlsx file instead of csv
//

include { XLSX_TO_CSV            } from '../../../modules/goodwright/xlsx_to_csv/main'
include { SAMPLESHEET_TO_BARCODE } from '../../../modules/goodwright/ultraplex/samplesheet_to_barcode/main'
include { ULTRAPLEX              } from '../../../modules/goodwright/ultraplex/ultraplex/main'

workflow DEMULTIPLEX {
    take:
    samplesheet // channel/file: [ [csv/xlsx] ]
    fastq       // channel/file: [ fastq ]

    main:
    // Init
    ch_versions    = Channel.empty()
    ch_samplesheet = Channel.empty()
    ch_fastq       = Channel.empty()

    // Resolve inputs
    if(samplesheet instanceof groovyx.gpars.dataflow.DataflowVariable || 
       samplesheet instanceof groovyx.gpars.dataflow.DataflowBroadcast) {
        ch_samplesheet = samplesheet
    } else {
        ch_samplesheet = Channel.from(samplesheet)
    }
    if(fastq instanceof groovyx.gpars.dataflow.DataflowVariable || 
       fastq instanceof groovyx.gpars.dataflow.DataflowBroadcast) {
        ch_fastq = fastq
    } else {
        ch_fastq = Channel.from(fastq)
    }

    /*
    * CHANNEL: Split out samplesheets that need to be converted from excel
    */
    ch_samplesheet_branch = ch_samplesheet
        .branch {
            row ->
                csv: row.toString().endsWith("csv")
                xlsx: row.toString().endsWith("xlsx")
        }
    //ch_samplesheet_branch.csv | view
    //ch_samplesheet_branch.xlsx | view

    /*
    * MODULE: Convert xlsx to csv
    */
    XLSX_TO_CSV (
        ch_samplesheet_branch.xlsx
    )
    ch_versions = ch_versions.mix(XLSX_TO_CSV.out.versions)

    /*
    * CHANNEL: Combine converted / non-converted channels
    */
    ch_csv_samplesheet = XLSX_TO_CSV.out.csv.mix( ch_samplesheet_branch.csv )

    /*
    * MODULE: Convert the samplesheet(s) into ultraplex input
    */
    SAMPLESHEET_TO_BARCODE (
        ch_csv_samplesheet.collect()
    )
    ch_versions = ch_versions.mix(SAMPLESHEET_TO_BARCODE.out.versions)
    //SAMPLESHEET_TO_BARCODE.out.csv | view

    /*
    * CHANNEL: Pull out params for ultraplex
    */
    ch_adapter = SAMPLESHEET_TO_BARCODE.out.samplesheet
        .splitCsv(header: ['sample_name', 'barcode_seq_5', 'barcode_seq_3', 'adapter_seq_3'], skip:1, sep:"," )
        .map { row -> [row.adapter_seq_3] }
        .collect()
        .map { it[0] }
    //ch_adapter | view

    /*
    * MODULE: Demultiplex the fastq file
    */
    ULTRAPLEX (
        [ [ id:"fastq" ], fastq ],
        SAMPLESHEET_TO_BARCODE.out.barcodes,
        ch_adapter
    )
    ch_versions = ch_versions.mix(ULTRAPLEX.out.versions)
    //ULTRAPLEX.out.fastq | view

    /*
    * CHANNEL: Create meta data using the samplesheet and the outputs from ultraplex
    */
    ch_meta_fastq = SAMPLESHEET_TO_BARCODE.out.samplesheet
        .splitCsv (header:true, sep:",")
        .combine (ULTRAPLEX.out.fastq)
        .map { row ->
            def match = []
            row[2].each { file -> if (file.name.contains(row[0]['Sample Name'])) { match << file } }
            [ row[0]['Sample Name'], row[0], match ]
        }
        .unique()
        .map { [ it[1], it[2] ] }
    //ch_meta_fastq | view

    emit:
    fastq    = ch_meta_fastq  // channel: [ val(meta), [ fastq ] ]
    versions = ch_versions    // channel: [ versions.yml ]
}
