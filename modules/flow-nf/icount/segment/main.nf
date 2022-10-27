process ICOUNT_SEGMENT {
    tag "$gtf"
    label "process_single"

    conda (params.enable_conda ? "bioconda::icount=2.0.0" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/icount:2.0.0--py_1' :
        'quay.io/biocontainers/icount:2.0.0--py_1' }"

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
    def prefix = task.ext.prefix ?: "${gtf.simpleName}.seg"
    """
    iCount segment \\
        $gtf \\
        ${prefix}.gtf \\
        $fai
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        icount: \$(echo \$(iCount --v 2>&1)
    END_VERSIONS
    """
}
