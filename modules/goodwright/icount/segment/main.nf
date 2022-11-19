process ICOUNT_SEGMENT {
    tag "$gtf"
    label "process_single"

    conda (params.enable_conda ? "bioconda::icount-mini=2.0.3" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/icount-mini:2.0.3--pyh5e36f6f_0' :
        'quay.io/biocontainers/icount-mini:2.0.3--pyh5e36f6f_0' }"

    input:
    tuple val(meta), path(gtf)
    path fai

    output:
    tuple val(meta), path("*.gtf"),emit: gtf
    path "versions.yml"           ,emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args   = task.ext.args ?: ''
    def prefix = task.ext.prefix ? "${gtf.simpleName}${task.ext.prefix}" : "${gtf.simpleName}.seg"
    """
    iCount-Mini segment \\
        $gtf \\
        ${prefix}.gtf \\
        $fai

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        icount: \$(echo \$(iCount --v 2>&1)
    END_VERSIONS
    """
}
