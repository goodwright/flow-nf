process SAMPLE_DIFF_SAMPLESHEET_CHECK {
    tag "$samplesheet"
    label 'process_single'

    conda "conda-forge::pandas=1.4.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pandas:1.4.3':
        'biocontainers/pandas:1.4.3' }"

    input:
    path samplesheet
    path counts
    val count_sep

    output:
    path '*.csv'        , emit: csv
    path '*.tsv'        , emit: counts, optional: true
    path  "versions.yml", emit: versions

    when:
    task.ext.when == null || task.ext.when

    shell:
    process_name = task.process
    output           = task.ext.output ?: 'samplesheet.valid.csv'
    add_multi_suffix = task.ext.add_multi_suffix ?: "False"
    template 'samplesheet_check.py'
}
