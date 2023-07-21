#!/usr/bin/env nextflow

include { SCMULTIOME_SAMPLESHEET_CHECK } from '../../../../modules/goodwright/sample/scmultiome_samplesheet_check'

/*
 * Valid checks
 */

workflow valid_single_sample_se {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_valid_single_sample_se'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow valid_single_sample_pe {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_valid_single_sample_pe'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow scmo_valid_pe_se_mixed {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_valid_pe_se_mixed'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow scmo_valid_multirep_se {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_valid_multirep_se'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow scmo_valid_multirep_pe {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_valid_multirep_pe'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow scmo_valid_merge_rep {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_valid_merge_rep'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow scmo_valid_extra_header {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_valid_extra_header'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

/*
 * Should fail checks
 */

workflow scmo_sample_spaces {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_sample_spaces'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow scmo_sample_blank {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_sample_blank'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow scmo_invalid_col_in_row {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_invalid_col_in_row'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow scmo_fastq_spaces {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_fastq_spaces'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow scmo_fastq_ext_error {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_fastq_ext_error'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}

workflow scmo_dot_in_sample {
    samplesheet = file(params.goodwright_test_data['samplesheets']['scmo_dot_in_sample'], checkIfExists: true)
    SCMULTIOME_SAMPLESHEET_CHECK ( samplesheet )
}
