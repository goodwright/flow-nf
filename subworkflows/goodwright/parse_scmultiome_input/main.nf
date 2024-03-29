/*
 * Check input samplesheet, get read channels and merge replicates if necessary.
 * Subworkflow goal is to output a valid, prepared set of fastq files with metadata
 */

include { SCMULTIOME_SAMPLESHEET_CHECK } from '../../../modules/goodwright/sample/scmultiome_samplesheet_check/main.nf'
include { CAT_FASTQ                    } from '../../../modules/nf-core/cat/fastq/main.nf'

workflow PARSE_SCMULTIOME_INPUT {
    take:
    samplesheet // file: /path/to/samplesheet.csv
    merge_fastq // value: boolean

    main:
    ch_versions = Channel.empty()

    /*
    * MODULE: Check the samplesheet for errors
    */
    SCMULTIOME_SAMPLESHEET_CHECK (
        samplesheet
    )

    /*
    * MODULE: Parse samplesheet into meta and fastq files
    */
    ch_fastq = SCMULTIOME_SAMPLESHEET_CHECK.out.csv
        .splitCsv ( header:true, sep:"," )
        .map { parse_meta(it) }

    if(merge_fastq) {
        /*
        * CHANNEL: Split out files which need merging
        */
        ch_fastq = ch_fastq
            .groupTuple(by: [0])
            .branch {
                meta, fastq ->
                    single  : fastq.size() == 1
                        return [ meta, fastq.flatten() ]
                    multiple: fastq.size() > 1
                        return [ meta, fastq.flatten() ]
            }

        /*
        * MODULE: Concatenate FastQ files from same sample if required
        */
        CAT_FASTQ (
            ch_fastq.multiple
        )
        ch_versions  = ch_versions.mix(CAT_FASTQ.out.versions)
        ch_fastq = CAT_FASTQ.out.reads.mix(ch_fastq.single)
    }

    emit:
    fastq    = ch_fastq // channel: [ val(meta), [ reads ] ]
    versions = ch_versions  // channel: [ versions.yml ]
}

// Function to get list of [ meta, [ fastq_1, fastq_2 ] ]
def parse_meta(LinkedHashMap row) {
    def meta = [:]
    meta.id        = row.sample
    meta.type      = row.type
    meta.protocol  = row.protocol
    meta.single_end = row.single_end.toBoolean()

    // Get the rest of the values
    def keys = row.keySet()
    for (key in keys) {
        if (key in ['id', 'type', 'protocol', 'single_end', 'fastq_1', 'fastq_2', 'expected_cells']) continue
        meta[key] = row[key]
    }

    // Check fastq files exist
    def array = []
    if (!file(row.fastq_1).exists()) {
        exit 1, "ERROR: Please check input samplesheet -> Read 1 FastQ file does not exist!\n${row.fastq_1}"
    }
    if (meta.single_end) {
        array = [ meta, [ file(row.fastq_1) ] ]
    } else {
        if (!file(row.fastq_2).exists()) {
            exit 1, "ERROR: Please check input samplesheet -> Read 2 FastQ file does not exist!\n${row.fastq_2}"
        }
        array = [ meta, [ file(row.fastq_1), file(row.fastq_2) ] ]
    }
    return array
}
