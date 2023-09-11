#!/usr/bin/env nextflow

include { PREPARE_REF } from '../../../../subworkflows/goodwright/prepare_genome/prepare_ref/main.nf'

def checkMetadata(channel, channelName) {
    channel.map { 
        if(!(it[0] instanceof java.util.LinkedHashMap)) { 
            error("No metadata detected in ${channelName}") 
        } 
    }
}

workflow test_compressed {

    fasta     = file(params.test_data['sarscov2']['genome']['genome_fasta_gz'], checkIfExists: true)
    gtf       = file(params.test_data['sarscov2']['genome']['genome_gff3_gz'], checkIfExists: true)
    bed       = file(params.test_data['sarscov2']['genome']['test_bed_gz'], checkIfExists: true)
    blacklist = file(params.goodwright_test_data['genome']['mm10_blacklist_gz'], checkIfExists: true)

    PREPARE_REF (
        fasta,
        gtf,
        bed,
        blacklist,
        [],
        []
    )

    def channelMapping = [
        [PREPARE_REF.out.fasta, "fasta"],
        [PREPARE_REF.out.gtf, "gtf"],
        [PREPARE_REF.out.bed, "bed"],
        [PREPARE_REF.out.blacklist, "blacklist"],
        [PREPARE_REF.out.chrom_sizes, "chrom_sizes"],
        [PREPARE_REF.out.fasta_fai, "fasta_fai"],
    ]

    // Check we have meta data in all channel outputs
    channelMapping.each { 
        def channelRef = it[0]
        def channelName = it[1]
        checkMetadata(channelRef, channelName) 
    }
}

workflow test_uncompressed {

    fasta     = file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)
    gtf       = file(params.test_data['sarscov2']['genome']['genome_gff3'], checkIfExists: true)
    bed       = file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true)
    blacklist = file(params.goodwright_test_data['genome']['mm10_blacklist'], checkIfExists: true)

    PREPARE_REF (
        fasta,
        gtf,
        bed,
        blacklist,
        [],
        []
    )

    def channelMapping = [
        [PREPARE_REF.out.fasta, "fasta"],
        [PREPARE_REF.out.gtf, "gtf"],
        [PREPARE_REF.out.bed, "bed"],
        [PREPARE_REF.out.blacklist, "blacklist"],
        [PREPARE_REF.out.chrom_sizes, "chrom_sizes"],
        [PREPARE_REF.out.fasta_fai, "fasta_fai"],
        
    ]

    // Check we have meta data in all channel outputs
    channelMapping.each { 
        def channelRef = it[0]
        def channelName = it[1]
        checkMetadata(channelRef, channelName) 
    }
}

workflow test_nullparams {

    PREPARE_REF (
        [],
        [],
        [],
        [],
        [],
        []
    )

    def channelMapping = [
        [PREPARE_REF.out.fasta, "fasta"],
        [PREPARE_REF.out.gtf, "gtf"],
        [PREPARE_REF.out.bed, "bed"],
        [PREPARE_REF.out.blacklist, "blacklist"],
        [PREPARE_REF.out.chrom_sizes, "chrom_sizes"],
        [PREPARE_REF.out.fasta_fai, "fasta_fai"],
        
    ]

    // Check we have meta data in all channel outputs
    channelMapping.each { 
        def channelRef = it[0]
        def channelName = it[1]
        checkMetadata(channelRef, channelName) 
    }
}

workflow test_chromsizes {

    fasta       = file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)
    gtf         = file(params.test_data['sarscov2']['genome']['genome_gff3'], checkIfExists: true)
    bed         = file(params.test_data['sarscov2']['genome']['test_bed'], checkIfExists: true)
    blacklist   = file(params.goodwright_test_data['genome']['mm10_blacklist'], checkIfExists: true)
    fasta_fai   = Channel.of([[:],file(params.goodwright_test_data['genome']['homosapien_chr22_fai'], checkIfExists: true)])
    chrom_sizes = Channel.of([[:],file(params.goodwright_test_data['genome']['homosapien_chr22_sizes'], checkIfExists: true)])

    PREPARE_REF (
        fasta,
        gtf,
        bed,
        blacklist,
        fasta_fai,
        chrom_sizes
    )

    def channelMapping = [
        [PREPARE_REF.out.fasta, "fasta"],
        [PREPARE_REF.out.gtf, "gtf"],
        [PREPARE_REF.out.bed, "bed"],
        [PREPARE_REF.out.blacklist, "blacklist"],
        [PREPARE_REF.out.chrom_sizes, "chrom_sizes"],
        [PREPARE_REF.out.fasta_fai, "fasta_fai"],
        
    ]

    // Check we have meta data in all channel outputs
    channelMapping.each { 
        def channelRef = it[0]
        def channelName = it[1]
        checkMetadata(channelRef, channelName) 
    }
}