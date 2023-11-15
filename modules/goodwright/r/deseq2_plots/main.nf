process R_DESEQ2_PLOTS {
    label 'process_medium'

    conda "bioconda::bioconductor-deseq2=1.34.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/bioconductor-deseq2:1.34.0--r41hc247a5b_3' :
        'biocontainers/bioconductor-deseq2:1.34.0--r41hc247a5b_3' }"

    input:
    tuple val(meta), path(rds)

    output:
    tuple val(meta), path("*.pdf")             , emit: pdf
    tuple val(meta), path("R_sessionInfo.log") , emit: session_info
    path "versions.yml"                        , emit: versions

    when:
    task.ext.when == null || task.ext.when

    shell:
    template 'deseq2_plots.R'
}
