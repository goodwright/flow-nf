#!/usr/bin/env nextflow

include { PREPARE_CLIPSEQ } from '../../../../subworkflows/flow-nf/prepare_genome/prepare_clipseq/main.nf'

workflow test_uncompressed {

    fasta       = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    smrna_fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf         = file(params.goodwright_test_data['genome']['gencode35_gtf'], checkIfExists: true)

    PREPARE_CLIPSEQ (
        fasta,
        smrna_fasta,
        gtf,
        [],
        []
    )
}

// workflow test_uncompressed {

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

// test with index