#!/usr/bin/env nextflow

include { LINUX_COMMAND as LINUX_COMMAND_DEFAULT    } from '../../../../modules/flow-nf/linux/command/main.nf'
include { LINUX_COMMAND as LINUX_COMMAND_WITHPARAMS } from '../../../../modules/flow-nf/linux/command/main.nf'
include { LINUX_COMMAND as LINUX_COMMAND_CMD2       } from '../../../../modules/flow-nf/linux/command/main.nf'
include { LINUX_COMMAND as LINUX_COMMAND_CMD2CPY    } from '../../../../modules/flow-nf/linux/command/main.nf'

workflow test_default {

    bed = [ [id:'test'], file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true) ]

    LINUX_COMMAND_DEFAULT (
        bed,
        [],
        false
    )
}

workflow test_withparams {

    bed = [ [id:'test'], file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true) ]

    LINUX_COMMAND_WITHPARAMS (
        bed,
        [],
        false
    )
}

workflow test_cmd2 {

    bed  = [ [id:'test'], file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true) ]
    bed2 = file(params.test_data['sarscov2']['genome']['test2_bed'], checkIfExists: true)

    LINUX_COMMAND_CMD2 (
        bed,
        bed2,
        false
    )
}

workflow test_cmd2cpy {

    bed  = [ [id:'test'], file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true) ]

    LINUX_COMMAND_CMD2CPY (
        bed,
        [],
        true
    )
}