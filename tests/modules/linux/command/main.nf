#!/usr/bin/env nextflow

include { LINUX_COMMAND as LINUX_COMMAND_DEFAULT    } from '../../../../modules/flow-nf/linux/command/main.nf'
include { LINUX_COMMAND as LINUX_COMMAND_WITHPARAMS } from '../../../../modules/flow-nf/linux/command/main.nf'

workflow test_default {

    bed = [ [id:'test'], file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true) ]

    LINUX_COMMAND_DEFAULT ( bed )
}

workflow test_withparams {

    bed = [ [id:'test'], file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true) ]

    LINUX_COMMAND_WITHPARAMS ( bed )
}