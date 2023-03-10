process R_GSEA {
    tag "${meta.id}"
    label 'process_medium'

    container 'chrischeshire/gsea:latest'

    input:
    tuple val(meta), path(deseq2_results)
    val organism

    // output:
    // tuple val(meta), path("*.deseq2.results.tsv")     , emit: results
    // tuple val(meta), path("*.dds.rld.rds")            , emit: rdata
    // tuple val(meta), path("*.deseq2.sizefactors.tsv") , emit: size_factors
    // tuple val(meta), path("*.normalised_counts.tsv")  , emit: normalised_counts
    // tuple val(meta), path("*.rlog.tsv")               , optional: true, emit: rlog_counts
    // tuple val(meta), path("*.vst.tsv")                , optional: true, emit: vst_counts
    // tuple val(meta), path("*.R_sessionInfo.log")      , emit: session_info
    // path "versions.yml"                               , emit: versions

    when:
    task.ext.when == null || task.ext.when

    shell:
    prefix = task.ext.prefix ?: "${meta.id}"
    template 'gsea.R'
}





    // deseq2_results = "!{deseq2_results}", # The input deseq2 results table
    // prefix = "!{prefix}",                 # Output prefix

    // # Results params
    // dsq_p_thresh = "!{dsq_p_thresh}", # Filter threshold for the deseq2 results table

    // # General GSEA params
    // gsea_p_cutoff = "!{gsea_p_cutoff}", # numeric of cutoff for both pvalue and adjusted pvalue, default should be 0.05
    // gsea_q_cutoff = "!{gsea_q_cutoff}", # numeric of cutoff for qvalue, default should be 0.15

    // # genekitr params
    // ontology = "!{ontology}", # Biological Processes (BP) | Molecular Functions (MF) | Cellular Components (CC)
    // organism = "!{organism}", # https://genekitr.online/docs/species.html
    // min_gset_size = "!{min_gset_size}", # Minimal size of each gene set for analysis. Default should be 10
    // max_gset_size = "!{max_gset_size}", #  Maximal size. Default should be 500.
    // p_adjust_method = "!{p_adjust_method}", # choose from “holm”, “hochberg”, “hommel”, “bonferroni”, “BH”, “BY”, “fdr”, “none”
    // pathway_count = "!{pathway_count}", # How many pathways to show on the plots
    // stats_metric = "!{stats_metric}", # Stats metric for the plots - c("p.adjust", "pvalue", "qvalue")
    // term_metric = "!{term_metric}", # Term metric for the ora plots - c("FoldEnrich", "GeneRatio", "Count", "RichFactor")
    // scale_ratio = "!{scale_ratio}",
    // main_text_size = "!{main_text_size}",
    // legend_text_size = "!{legend_text_size}",