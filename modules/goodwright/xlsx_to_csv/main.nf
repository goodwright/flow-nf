process XLSX_TO_CSV {
    tag "$xlsx"
    label "process_single"

    conda "conda-forge::pandas=1.5.0,conda-forge::openpyxl=3.0.10"
    container "quay.io/goodwright/mulled-v2-9f99278ff296588175d0d58987544943664a125d:8138e3cc65206377a94c0f6e31a69503ee4c7e97-0"

    input:
    path xlsx

    output:
    path "*.csv"         , emit: csv
    path  "versions.yml" , emit: versions

    when:
    task.ext.when == null || task.ext.when

    shell:
    process_name = task.process
    output       = task.ext.output ?: "${xlsx.simpleName}.csv"
    template 'xlsx_to_csv.py'
}
