#!/usr/bin/env nextflow

include { CLIP_CALC_CROSSLINKS } from '../../../subworkflows/goodwright/clip_calc_crosslinks/main.nf'

workflow test {

    bam = [ [id:'test'], [ file(params.goodwright_test_data['clip']['bam'], checkIfExists: true) ]]
    fai = file(params.goodwright_test_data['clip']['fai'], checkIfExists: true)

    CLIP_CALC_CROSSLINKS ( 
        bam,
        fai 
    )
}
