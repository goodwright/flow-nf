process XLSX_TO_CSV {
    tag "$xlsx"
    label "process_low"

    container "quay.io/biocontainers/pandas:1.1.5"

    input:
    path xlsx

    output:
    path "*.csv", emit: csv

    script:
    """
    pip install openpyxl
    python -c "import pandas as pd; data = pd.read_excel('$xlsx', engine='openpyxl'); data.to_csv('$xlsx' + '.csv', index=False)"
    """
}

"mulled-v2-9f99278ff296588175d0d58987544943664a125d"




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
    path "*.csv"         , emit: csv
    path  "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    shell:
    process_name = task.process
    output       = task.ext.output ?: 'barcodes.csv'
    template 'clip_samplesheet_to_barcode.py'
}
