#!/usr/bin/env nextflow

include { SAMPLE_BASE_SAMPLESHEET_CHECK } from '../../../../modules/goodwright/sample/base_samplesheet_check'

/*
 * Valid checks
 */

workflow test_valid_single_pe {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_single_pe'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_valid_single_se {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_single_se'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_valid_multi_pe {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_multi_pe'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_valid_multi_se {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_multi_se'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_valid_header_extra {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_header_exta'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_valid_merge_rep {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_valid_merge_rep'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}


/*
 * Should fail checks
 */

workflow test_invalid_mixed {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_invalid_mixed'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_invalid_dot_sampleid {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_invalid_dot_sampleid'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_invalid_dup_rows {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_invalid_dup_rows'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_invalid_fastq_ext_error {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_invalid_fastq_ext_error'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_invalid_fastq_spaces {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_invalid_fastq_spaces'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_invalid_group_blank {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_invalid_group_blank'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_invalid_group_spaces {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_invalid_group_spaces'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_invalid_colinrow {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_invalid_invalid_colinrow'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_invalid_negrepnum {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_invalid_negrepnum'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}

workflow test_invalid_rep_start {
    samplesheet = file(params.goodwright_test_data['samplesheets']['base_invalid_rep_start'], checkIfExists: true)
    SAMPLE_BASE_SAMPLESHEET_CHECK ( samplesheet )
}
