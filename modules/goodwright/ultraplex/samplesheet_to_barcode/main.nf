process SAMPLESHEET_TO_BARCODE {
    tag "$samplesheet"
    label "process_single"

    conda "conda-forge::pandas=1.4.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pandas:1.4.3':
        'quay.io/biocontainers/pandas:1.4.3' }"

    input:
    path samplesheet

    output:
    path "barcodes.csv"    , emit: barcodes
    path "samplesheet.csv" , emit: samplesheet
    path  "versions.yml"   , emit: versions

    when:
    task.ext.when == null || task.ext.when

    shell:
    process_name = task.process
    output       = 'barcodes.csv'
    template 'samplesheet_to_barcode.py'
}
