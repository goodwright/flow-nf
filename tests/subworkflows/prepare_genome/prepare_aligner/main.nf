#!/usr/bin/env nextflow

include { PREPARE_ALINGER as PREPARE_ALINGER_FASTA  } from '../../../../subworkflows/goodwright/prepare_genome/prepare_aligner/main.nf'
include { PREPARE_ALINGER as PREPARE_ALINGER_FOLDER } from '../../../../subworkflows/goodwright/prepare_genome/prepare_aligner/main.nf'

def checkMetadata(channel, channelName) {
    channel.map { 
        if(!(it[0] instanceof java.util.LinkedHashMap)) { 
            error("No metadata detected in ${channelName}") 
        } 
    }
}

workflow test_fasta {

    fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf   = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)

    // Test indexing with fasta file
    PREPARE_ALINGER_FASTA (
        ["bowtie", "star"],
        fasta,
        gtf,
        [],
        []
    )

    // Pass those indexes through as folders (test data is too large to be kept in repo)
    PREPARE_ALINGER_FOLDER (
        ["bowtie", "star"],
        fasta,
        gtf,
        PREPARE_ALINGER_FASTA.out.bt_index.map{ it[1] }.collect(),
        PREPARE_ALINGER_FASTA.out.star_index.map{ it[1] }.collect()
    )

    def channelMapping = [
        [PREPARE_ALINGER_FASTA.out.bt_index, "bt_index"],
        [PREPARE_ALINGER_FASTA.out.star_index, "star_index"],
    ]

    // Check we have meta data in all channel outputs
    channelMapping.each { 
        def channelRef = it[0]
        def channelName = it[1]
        checkMetadata(channelRef, channelName) 
    }
}


workflow test_fasta_channels {

    fasta = Channel.from([[ [:], file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true) ]])
    gtf   = Channel.from([[ [:], file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true) ]])

    // Test indexing with fasta file
    PREPARE_ALINGER_FASTA (
        ["bowtie", "star"],
        fasta,
        gtf,
        [],
        []
    )

    // Pass those indexes through as folders (test data is too large to be kept in repo)
    PREPARE_ALINGER_FOLDER (
        ["bowtie", "star"],
        fasta,
        gtf,
        PREPARE_ALINGER_FASTA.out.bt_index.map{ it[1] }.collect(),
        PREPARE_ALINGER_FASTA.out.star_index.map{ it[1] }.collect()
    )

    def channelMapping = [
        [PREPARE_ALINGER_FOLDER.out.bt_index, "bt_index"],
        [PREPARE_ALINGER_FOLDER.out.star_index, "star_index"],
    ]

    // Check we have meta data in all channel outputs
    channelMapping.each { 
        def channelRef = it[0]
        def channelName = it[1]
        checkMetadata(channelRef, channelName) 
    }
}

workflow test_tar {

    fasta         = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf           = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)
    bowtie_index  = file(params.goodwright_test_data['aligners']['bowtie2_index_tar'], checkIfExists: true)
    star_index    = file(params.goodwright_test_data['aligners']['star_index_tar'], checkIfExists: true)

    PREPARE_ALINGER_FASTA (
        ["bowtie", "star"],
        fasta,
        gtf,
        bowtie_index,
        star_index
    )

    def channelMapping = [
        [PREPARE_ALINGER_FASTA.out.bt_index, "bt_index"],
        [PREPARE_ALINGER_FASTA.out.star_index, "star_index"],
    ]

    // Check we have meta data in all channel outputs
    channelMapping.each { 
        def channelRef = it[0]
        def channelName = it[1]
        checkMetadata(channelRef, channelName) 
    }
}

workflow test_nullparams {

    fasta = file(params.test_data['homo_sapiens']['genome']['genome_fasta'], checkIfExists: true)
    gtf   = file(params.test_data['homo_sapiens']['genome']['genome_gtf'], checkIfExists: true)

    PREPARE_ALINGER_FASTA (
        [],
        fasta,
        gtf,
        [],
        []
    )

    def channelMapping = [
        [PREPARE_ALINGER_FASTA.out.bt_index, "bt_index"],
        [PREPARE_ALINGER_FASTA.out.star_index, "star_index"],
    ]

    // Check we have meta data in all channel outputs
    channelMapping.each { 
        def channelRef = it[0]
        def channelName = it[1]
        checkMetadata(channelRef, channelName) 
    }
}