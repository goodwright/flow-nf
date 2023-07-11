//
// Prepares genome reference files for nf-core/scrnaseq
//

include { GUNZIP as GUNZIP_FASTA } from '../../../../modules/nf-core/gunzip/main.nf'
include { GUNZIP as GUNZIP_GTF   } from '../../../../modules/nf-core/gunzip/main.nf'
include { CELLRANGER_MKGTF       } from '../../../../modules/nf-core/cellranger/mkgtf/main'
include { CELLRANGER_MKREF       } from '../../../../modules/nf-core/cellranger/mkref/main'

workflow PREPARE_SCRNASEQ {
    take:
    fasta                //      file: /path/to/genome.fasta
    gtf                  //      file: /path/to/genome.gtf

    main:
    ch_versions = Channel.empty()

    //
    // MODULE: Uncompress genome fasta file if required
    //
    ch_fasta = Channel.empty()
    if (fasta.toString().endsWith(".gz")) {
        ch_fasta    = GUNZIP_FASTA ( [ [id:fasta.baseName], fasta ] ).gunzip
        ch_versions = ch_versions.mix(GUNZIP_FASTA.out.versions)
    } else {
        ch_fasta = Channel.of([ [id:fasta.baseName], fasta ])
    }
    // EXAMPLE CHANNEL STRUCT: [[meta], fasta]
    //ch_fasta | view

    //
    // MODULE: Uncompress genome gtf file if required
    //
    ch_gtf = Channel.empty()
    if (gtf.toString().endsWith(".gz")) {
        ch_gtf      = GUNZIP_GTF ( [ [id:gtf.baseName], gtf ] ).gunzip
        ch_versions = ch_versions.mix(GUNZIP_GTF.out.versions)
    } else {
        ch_gtf = Channel.of([ [id:gtf.baseName], gtf ])
    }
    // EXAMPLE CHANNEL STRUCT: [[meta], gtf]
    //ch_gtf | view

    //
    // MODULE: Create Cell ranger compatable GTF file - Filter GTF based on gene biotypes passed in params.modules
    //
    // 
    CELLRANGER_MKGTF( gtf )
    ch_versions = ch_versions.mix(CELLRANGER_MKGTF.out.versions)

    // Make reference genome
    CELLRANGER_MKREF( fasta, CELLRANGER_MKGTF.out.gtf, "cellranger_reference" )
    ch_versions = ch_versions.mix(CELLRANGER_MKREF.out.versions)
    cellranger_index = CELLRANGER_MKREF.out.reference



    // /*
    // * Build salmon index
    // */
    // if (!salmon_index) {
    //     SIMPLEAF_INDEX( genome_fasta, transcript_fasta, gtf )
    //     salmon_index = SIMPLEAF_INDEX.out.index.collect()
    //     transcript_tsv = SIMPLEAF_INDEX.out.transcript_tsv.collect()
    //     ch_versions = ch_versions.mix(SIMPLEAF_INDEX.out.versions)

    //     if (!txp2gene) { 
    //         txp2gene = SIMPLEAF_INDEX.out.transcript_tsv 
    //     }
    // }
    // /*
    // * Generate Kallisto Gene Map if not supplied and index is given
    // * If no index is given, the gene map will be generated in the 'kb ref' step
    // */
    // if (!txp2gene && kallisto_index) {
    //     GENE_MAP( gtf )
    //     txp2gene = GENE_MAP.out.gene_map
    //     ch_versions = ch_versions.mix(GENE_MAP.out.versions)
    // }

    // /*
    // * Generate kallisto index
    // */
    // if (!kallisto_index) {
    //     KALLISTOBUSTOOLS_REF( genome_fasta, gtf, kb_workflow )
    //     txp2gene = KALLISTOBUSTOOLS_REF.out.t2g.collect()
    //     kallisto_index = KALLISTOBUSTOOLS_REF.out.index.collect()
    //     ch_versions = ch_versions.mix(KALLISTOBUSTOOLS_REF.out.versions)
    //     t1c = KALLISTOBUSTOOLS_REF.out.cdna_t2c.ifEmpty{ [] }
    //     t2c = KALLISTOBUSTOOLS_REF.out.intron_t2c.ifEmpty{ [] }
    // }

    //     if (!star_index) {
    //     STAR_GENOMEGENERATE( genome_fasta, gtf )
    //     star_index = STAR_GENOMEGENERATE.out.index.collect()
    //     ch_versions = ch_versions.mix(STAR_GENOMEGENERATE.out.versions)
    // }


    emit:
    versions   = ch_versions // channel: [ versions.yml ]
}
