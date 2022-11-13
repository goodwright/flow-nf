#!/usr/bin/env nextflow

include { FASTQC_TRIMGALORE } from '../../../subworkflows/goodwright/fastqc_trimgalore/main.nf'

workflow test_noskip_paired {

    fastq = [ [id:"test", single_end:false], [file(params.test_data['sarscov2']['illumina']['test_1_fastq_gz'], checkIfExists: true), file(params.test_data['sarscov2']['illumina']['test_2_fastq_gz'], checkIfExists: true)] ]

    FASTQC_TRIMGALORE (
        fastq,
        false,
        false
    )
}

workflow test_noskip_single {

    fastq = [ [id:"test", single_end:true], [file(params.test_data['sarscov2']['illumina']['test_1_fastq_gz'], checkIfExists: true)] ]

    FASTQC_TRIMGALORE (
        fastq,
        false,
        false
    )
}

workflow test_skip_fastqc {

    fastq = [ [id:"test", single_end:true], [file(params.test_data['sarscov2']['illumina']['test_1_fastq_gz'], checkIfExists: true)] ]

    FASTQC_TRIMGALORE (
        fastq,
        true,
        false
    )
}

workflow test_skip_trim {

    fastq = [ [id:"test", single_end:true], [file(params.test_data['sarscov2']['illumina']['test_1_fastq_gz'], checkIfExists: true)] ]

    FASTQC_TRIMGALORE (
        fastq,
        false,
        true
    )
}

workflow test_skip_all {

    fastq = [ [id:"test", single_end:true], [file(params.test_data['sarscov2']['illumina']['test_1_fastq_gz'], checkIfExists: true)] ]

    FASTQC_TRIMGALORE (
        fastq,
        true,
        true
    )
}