process CLIP_SAMPLESHEET_TO_BARCODE {
    tag "$samplesheet"
    label "process_single"

    container "quay.io/biocontainers/pandas:1.1.5"
    conda (params.enable_conda ? "conda-forge::pandas=1.1.5" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pandas:1.1.5':
        'quay.io/biocontainers/pandas:1.1.5' }"

    input:
    path samplesheet

    output:
    path "*.csv", emit: csv

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    template "clip_samplesheet_to_barcode.py"
}
