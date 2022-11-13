process CLIP_SAMPLESHEET_TO_BARCODE {
    tag "$samplesheet"
    label "process_single"

    conda (params.enable_conda ? "conda-forge::pandas=1.4.3" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pandas:1.4.3':
        'quay.io/biocontainers/pandas:1.4.3' }"

    input:
    path samplesheet

    output:
    path "*.csv"         , emit: csv
    path  "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    shell:
    process_name = task.process
    output       = task.ext.output ?: 'barcodes.csv'
    template 'clip_samplesheet_to_barcode.py'
}
