process ICOUNT_RNAMAPS {
    tag "$meta.id"
    label "process_low"

    conda (params.enable_conda ? "bioconda::icount-mini=2.0.3" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/icount-mini:2.0.3--pyh5e36f6f_0"
    } else {
        container "quay.io/biocontainers/icount-mini:2.0.3--pyh5e36f6f_0"
    }

    input:
    tuple val(meta), path(bed)
    path segmentation

    output:
    tuple val(meta), path("rnamaps*"), emit: tsv
    path "versions.yml"              , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args   = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    iCount-Mini rnamaps \\
        $bed \\
        $segmentation \\
        $args

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        iCount-Mini: \$(iCount-Mini -v)
    END_VERSIONS
    """
}
