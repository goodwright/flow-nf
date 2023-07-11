#!/usr/bin/env nextflow

include { PREPARE_SCRNASEQ } from '../../../../subworkflows/goodwright/prepare_genome/prepare_scrnaseq/main'

workflow test_compressed {

    fasta = file(params.test_data['sarscov2']['genome']['genome_fasta_gz'], checkIfExists: true)
    gtf   = file(params.test_data['sarscov2']['genome']['genome_gff3_gz'], checkIfExists: true)

    PREPARE_SCRNASEQ (
        fasta,
        gtf
    )
}

// workflow test_uncompressed {

    // fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    // gtf   = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)

//     fasta     = file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)
//     gtf       = file(params.test_data['sarscov2']['genome']['genome_gff3'], checkIfExists: true)
//     bed       = file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true)
//     blacklist = file(params.goodwright_test_data['genome']['mm10_blacklist'], checkIfExists: true)

//     PREPARE_REF (
//         fasta,
//         gtf,
//         bed,
//         blacklist
//     )
// }
