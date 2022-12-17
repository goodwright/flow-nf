process R_DESEQ2_PLOTS {
    tag "$meta"
    label 'process_medium'

    conda (params.enable_conda ? "bioconda::bioconductor-deseq2=1.34.0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/bioconductor-deseq2:1.34.0--r41hc247a5b_3' :
        'quay.io/biocontainers/bioconductor-deseq2:1.34.0--r41hc247a5b_3' }"

    input:
    tuple val(meta), path(rds)

    // output:
    // tuple val(meta), path("*.deseq2.results.tsv")              , emit: results
    // tuple val(meta), path("*.dds.rld.rds")                     , emit: rdata
    // tuple val(meta), path("*.deseq2.sizefactors.tsv")          , emit: size_factors
    // tuple val(meta), path("*.normalised_counts.tsv")           , emit: normalised_counts
    // tuple val(meta), path("*.rlog.tsv")                        , optional: true, emit: rlog_counts
    // tuple val(meta), path("*.vst.tsv")                         , optional: true, emit: vst_counts
    // tuple val(meta), path("*.R_sessionInfo.log")               , emit: session_info
    // path "versions.yml"                                        , emit: versions

    when:
    task.ext.when == null || task.ext.when

    shell:
    // contrast_variable = contrast ?: "condition"
    // reference_level = reference ?: "NO_REF"
    // treatment_level = treatment ?: "NO_TREAT"
    // blocking_variables = blocking ?: ""
    template 'deseq2_plots.R'
}
