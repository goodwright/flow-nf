#!/usr/bin/env nextflow

include { summary_log } from '../../../../modules/goodwright/util/logging/main.nf'

workflow test_nodebug {

    log.info summary_log(workflow, params, false, params.monochrome_logs)
}

workflow test_debug {

    log.info summary_log(workflow, params, true, params.monochrome_logs)
}
