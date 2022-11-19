/*
 * Check input samplesheet and get read channels
 */

include { SAMPLE_BASE_SAMPLESHEET_CHECK } from '../../../modules/goodwright/sample/base_samplesheet_check/main.nf'

workflow PARSE_INPUT {
    take:
    samplesheet // file: /path/to/samplesheet.csv

    main:
    /*
    * MODULE: Check the samplesheet for errors
    */
    SAMPLE_BASE_SAMPLESHEET_CHECK (
        samplesheet
    )

    /*
    * MODULE: Parse samplesheet into meta and fastq files
    */
    SAMPLE_BASE_SAMPLESHEET_CHECK.out.csv
        .splitCsv ( header:true, sep:"," )
        .map { parse_meta(it) }
        .set { reads }

    emit:
    reads // channel: [ val(meta), [ reads ] ]
    versions = SAMPLE_BASE_SAMPLESHEET_CHECK.out.versions
}

// Function to get list of [ meta, [ fastq_1, fastq_2 ] ]
def parse_meta(LinkedHashMap row) {
    def meta = [:]
    meta.id         = row.id
    meta.group      = row.group
    meta.replicate  = row.replicate.toInteger()
    meta.single_end = row.single_end.toBoolean()

    // Get the rest of the values
    def keys = row.keySet()
    for (key in keys) {
        if (key in ['id', 'group', 'replicate', 'single_end', 'fastq_1', 'fastq_2']) continue
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
