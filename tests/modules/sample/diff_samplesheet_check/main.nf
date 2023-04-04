#!/usr/bin/env nextflow

include { SAMPLE_DIFF_SAMPLESHEET_CHECK } from '../../../../modules/goodwright/sample/diff_samplesheet_check'

/*
 * Valid checks
 */

workflow test_valid_condition {
    samplesheet = file(params.goodwright_test_data['samplesheets']['diff_valid_condition'], checkIfExists: true)
    counts      = file(params.goodwright_test_data['count_matrix']['simple'], checkIfExists: true)

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        ','
    )
}

workflow test_valid_condition_factor {
    samplesheet = file(params.goodwright_test_data['samplesheets']['diff_valid_condition_factor'], checkIfExists: true)
    counts      = file(params.goodwright_test_data['count_matrix']['simple'], checkIfExists: true)

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        ','
    )
}

workflow test_valid_multicount {

    samplesheet = file(params.goodwright_test_data['samplesheets']['diff_valid_condition_multi'], checkIfExists: true)
    counts      = [
        file(params.goodwright_test_data['count_matrix']['s1'], checkIfExists: true),
        file(params.goodwright_test_data['count_matrix']['s2'], checkIfExists: true),
        file(params.goodwright_test_data['count_matrix']['s3'], checkIfExists: true),
        file(params.goodwright_test_data['count_matrix']['s4'], checkIfExists: true),
        file(params.goodwright_test_data['count_matrix']['s5'], checkIfExists: true)
    ]

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        '\t'
    )
}


/*
 * Should fail checks
 */


workflow test_check_dup_rows {
    samplesheet = file(params.goodwright_test_data['samplesheets']['dup_rows'], checkIfExists: true)
    counts      = file(params.goodwright_test_data['count_matrix']['simple'], checkIfExists: true)

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        ','
    )
}

workflow test_row_check_dots {
    samplesheet = file(params.goodwright_test_data['samplesheets']['row_check_dots'], checkIfExists: true)
    counts      = file(params.goodwright_test_data['count_matrix']['simple'], checkIfExists: true)

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        ','
    )
}

workflow test_row_check_num_col {
    samplesheet = file(params.goodwright_test_data['samplesheets']['row_check_num_col'], checkIfExists: true)
    counts      = file(params.goodwright_test_data['count_matrix']['simple'], checkIfExists: true)

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        ','
    )
}

workflow test_row_check_num_content {
    samplesheet = file(params.goodwright_test_data['samplesheets']['row_check_num_content'], checkIfExists: true)
    counts      = file(params.goodwright_test_data['count_matrix']['simple'], checkIfExists: true)

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        ','
    )
}

workflow test_row_check_spaces_1 {
    samplesheet = file(params.goodwright_test_data['samplesheets']['row_check_spaces_1'], checkIfExists: true)
    counts      = file(params.goodwright_test_data['count_matrix']['simple'], checkIfExists: true)

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        ','
    )
}

workflow test_row_check_spaces_2 {
    samplesheet = file(params.goodwright_test_data['samplesheets']['row_check_spaces_2'], checkIfExists: true)
    counts      = file(params.goodwright_test_data['count_matrix']['simple'], checkIfExists: true)

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        ','
    )
}

workflow test_sample_noin_counts {
    samplesheet = file(params.goodwright_test_data['samplesheets']['sample_notin_counts'], checkIfExists: true)
    counts      = file(params.goodwright_test_data['count_matrix']['simple'], checkIfExists: true)

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        ','
    )
}

workflow test_sample_noin_samplesheet {
    samplesheet = file(params.goodwright_test_data['samplesheets']['diff_valid_condition_factor'], checkIfExists: true)
    counts      = file(params.goodwright_test_data['count_matrix']['simple_6'], checkIfExists: true)

    SAMPLE_DIFF_SAMPLESHEET_CHECK (
        samplesheet,
        counts,
        ','
    )
}
