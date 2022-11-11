process LINUX_COMMAND {
    tag "$meta.id"
    label 'process_single'

    conda (params.enable_conda ? "conda-forge::sed=4.7" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/ubuntu:20.04' :
        'ubuntu:20.04' }"

    input:
    tuple val(meta), path(input)

    output:
    tuple val(meta), path("*.cmd.*"), emit: file
    path  "versions.yml"            , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args   = task.ext.args ?: 'echo "NO-ARGS"'
    def prefix = task.ext.suffix ? "${meta.id}${task.ext.suffix}" : "${meta.id}"
    def ext    = task.ext.ext ?: 'txt'

    """
    cat $input | $args > ${prefix}.cmd.${ext}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        linux: NOVERSION
    END_VERSIONS
    """
}
