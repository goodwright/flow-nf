//
// Uncompresses and prepares genome reference files
//

include { GUNZIP as GUNZIP_FASTA     } from '../../../../modules/nf-core/gunzip/main.nf'
include { GUNZIP as GUNZIP_GTF       } from '../../../../modules/nf-core/gunzip/main.nf'
include { GUNZIP as GUNZIP_BED       } from '../../../../modules/nf-core/gunzip/main.nf'
include { GUNZIP as GUNZIP_BLACKLIST } from '../../../../modules/nf-core/gunzip/main.nf'
include { CUSTOM_GETCHROMSIZES       } from '../../../../modules/nf-core/custom/getchromsizes/main.nf'

workflow PREPARE_REF {
    take:
    // MUST TAKE FILES AS INPUT WITH NO CHANNEL STRUCT FOR GZIPPED
    fasta       // channel: [ fasta/fasta.gz ]
    gtf         // channel: [ gtf/gtf.gz ]
    bed         // channel: [ bed/bed.gz ]
    blacklist   // channel: [ bed/bed.gz ]
    fasta_fai   // channel: [ [:], fasta.fai ]
    chrom_sizes // channel: [ [:], sizes ]

    main:
    ch_versions = Channel.empty()
    ch_chrom_sizes = Channel.empty()
    ch_fasta_fai   = Channel.empty()

    if(chrom_sizes) {
        ch_chrom_sizes = chrom_sizes
        if(!(chrom_sizes instanceof groovyx.gpars.dataflow.DataflowVariable || 
        chrom_sizes instanceof groovyx.gpars.dataflow.DataflowBroadcast)) {
            ch_chrom_sizes = Channel.of([[:], chrom_sizes])
        }
    }

    if(fasta_fai) {
        ch_fasta_fai = fasta_fai
        if(!(fasta_fai instanceof groovyx.gpars.dataflow.DataflowVariable || 
        fasta_fai instanceof groovyx.gpars.dataflow.DataflowBroadcast)) {
            ch_fasta_fai = Channel.of([[:], fasta_fai])
        }
    }

    /*
    * MODULE: Uncompress genome fasta file if required
    */
    ch_fasta = Channel.empty()
    if (fasta.toString().endsWith(".gz")) {
        ch_fasta    = GUNZIP_FASTA ( [ [id:fasta.baseName], fasta ] ).gunzip
        ch_versions = ch_versions.mix(GUNZIP_FASTA.out.versions)
    }
    else if (fasta) {
        ch_fasta = Channel.from( [ [ [id:fasta.baseName], fasta ] ] )
    }

    /*
    * MODULE: Uncompress genome GTF file if required
    */
    ch_gtf = Channel.empty()
    if (gtf.toString().endsWith(".gz")) {
        ch_gtf      = GUNZIP_GTF ( [ [id:gtf.baseName], gtf ] ).gunzip
        ch_versions = ch_versions.mix(GUNZIP_GTF.out.versions)
    }
    else if (gtf) {
        ch_gtf = Channel.from( [ [ [id:gtf.baseName], gtf ] ] )
    }

    /*
    * MODULE: Uncompress genome BED file if required
    */
    ch_bed = Channel.empty()
    if (bed.toString().endsWith(".gz")) {
        ch_bed      = GUNZIP_BED ( [ [id:bed.baseName], bed ] ).gunzip
        ch_versions = ch_versions.mix(GUNZIP_BED.out.versions)
    }
    else if (bed) {
        ch_bed = Channel.from( [ [ [id:bed.baseName], bed ] ] )
    }

    /*
    * MODULE: Uncompress blacklist BED file if required
    */
    ch_blacklist = Channel.empty()
    if (blacklist.toString().endsWith(".gz")) {
        ch_blacklist = GUNZIP_BLACKLIST ( [ [id:blacklist.baseName], blacklist ] ).gunzip
        ch_versions  = ch_versions.mix(GUNZIP_BLACKLIST.out.versions)
    }
    else if (blacklist) {
        ch_blacklist = Channel.from( [ [ [id:blacklist.baseName], blacklist ] ] )
    }

    /*
    * MODULE: Create chromosome sizes file and index genome file
    */
    if (fasta) {
        if (!(fasta_fai && chrom_sizes)) {
            CUSTOM_GETCHROMSIZES (
                ch_fasta
            )
            ch_chrom_sizes = CUSTOM_GETCHROMSIZES.out.sizes
            ch_fasta_fai   = CUSTOM_GETCHROMSIZES.out.fai
            ch_versions    = ch_versions.mix(CUSTOM_GETCHROMSIZES.out.versions)
        }
    }

    emit:
    fasta       = ch_fasta       // channel: [ val(meta), [ fasta ] ]
    gtf         = ch_gtf         // channel: [ val(meta), [ gtf ] ]
    bed         = ch_bed         // channel: [ val(meta), [ bed ] ]
    blacklist   = ch_blacklist   // channel: [ val(meta), [ bed ] ]
    chrom_sizes = ch_chrom_sizes // channel: [ val(meta), [ txt ] ]
    fasta_fai   = ch_fasta_fai   // channel: [ val(meta), [ fai ] ]
    versions    = ch_versions    // channel: [ versions.yml ]
}