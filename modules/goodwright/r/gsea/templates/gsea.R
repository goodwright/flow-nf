#!/usr/bin/env Rscript

################################################
################################################
## Functions                                  ##
################################################
################################################

#' Parse out options from a string without recourse to optparse
#'
#' @param x Long-form argument list like --opt1 val1 --opt2 val2
#'
#' @return named list of options and values similar to optparse
parse_args <- function(x){
    args_list <- unlist(strsplit(x, ' ?--')[[1]])[-1]
    args_vals <- unlist(lapply(args_list, function(y) strsplit(y, ' +')), recursive = FALSE)

    # Ensure the option vectors are length 2 (key/ value) to catch empty ones
    args_vals <- lapply(args_vals, function(z){ length(z) <- 2; z})

    parsed_args <- structure(lapply(args_vals, function(x) x[2]), names = lapply(args_vals, function(x) x[1]))
    parsed_args[! is.na(parsed_args)]
}

#' Flexibly read CSV or TSV files
#'
#' @param file Input file
#' @param header Passed to read.delim()
#' @param row.names Passed to read.delim()
#'
#' @return output Data frame
read_delim_flexible <- function(file, header = TRUE, row.names = NULL){

    ext <- tolower(tail(strsplit(basename(file), split = "\\.")[[1]], 1))

    if (ext == "tsv" || ext == "txt") {
        separator <- "\t"
    } else if (ext == "csv") {
        separator <- ","
    } else {
        stop(paste("Unknown separator for", ext))
    }

    read.delim(
        file,
        sep = separator,
        header = header,
        row.names = row.names
    )
}

#####################################################
#####################################################
## PARSE PARAMETERS FROM NEXTFLOW AND COMMAND LINE ##
#####################################################
#####################################################

# Set defaults and classes
opt <- list(
    cores = 1,                            # Number of cores to use
    deseq2_results = "!{deseq2_results}", # The input deseq2 results table
    prefix = "!{prefix}",                 # Output prefix

    # Results params
    dsq_p_thresh = "!{dsq_p_thresh}", # Filter threshold for the deseq2 results table

    # General GSEA params
    gsea_p_cutoff = "!{gsea_p_cutoff}", # numeric of cutoff for both pvalue and adjusted pvalue, default should be 0.05
    gsea_q_cutoff = "!{gsea_q_cutoff}", # numeric of cutoff for qvalue, default should be 0.15

    # genekitr params
    ontology = "!{ontology}", # Biological Processes (BP) | Molecular Functions (MF) | Cellular Components (CC)
    organism = "!{organism}", # https://genekitr.online/docs/species.html
    min_gset_size = "!{min_gset_size}", # Minimal size of each gene set for analysis. Default should be 10
    max_gset_size = "!{max_gset_size}", #  Maximal size. Default should be 500.
    p_adjust_method = "!{p_adjust_method}", # choose from “holm”, “hochberg”, “hommel”, “bonferroni”, “BH”, “BY”, “fdr”, “none”
    pathway_count = "!{pathway_count}", # How many pathways to show on the plots
    stats_metric = "!{stats_metric}", # Stats metric for the plots - c("p.adjust", "pvalue", "qvalue")


    # KEGG params
    kegg_cat = "!{kegg_cat}", # “pathway”,“module”, “enzyme”, “disease” (human only), “drug” (human only) or “network” (human only)

    # General Plotting params
    plot_width = 1800,
    plot_height = 1200,
    plot_res = 300
)
opt_types <- lapply(opt, class)

# Parse command line args
cl_args <- commandArgs(trailingOnly=TRUE)
cl_keys <- grep("^--", cl_args, value = TRUE)
cl_opt <- list()
for (key in cl_keys) {
    key_index <- which(cl_args == key)
    value <- cl_args[key_index + 1]
    cl_opt[[sub("^--", "", key)]] <- value
}

# Override defaults with command line args
opt <- modifyList(opt, cl_opt)

# Apply parameter overrides
args_opt <- parse_args("!{task.ext.args}")
for ( ao in names(args_opt)){
    if (! ao %in% names(opt)){
        stop(paste("Invalid option:", ao))
    } else{
        # Preserve classes from defaults where possible
        if (! is.null(opt[[ao]])){
            args_opt[[ao]] <- as(args_opt[[ao]], opt_types[[ao]])
        }
        opt[[ao]] <- args_opt[[ao]]
    }
}

# Set nulls for required params that havent been resolved
if (startsWith(opt$organism, "!")) { opt$organism <- NULL }
if (startsWith(opt$prefix, "!")) { opt$prefix <- NULL }

# Check if required parameters have been provided
required_opts <- c('deseq2_results', 'organism', 'prefix')
missing <- required_opts[unlist(lapply(opt[required_opts], is.null)) | ! required_opts %in% names(opt)]

if (length(missing) > 0){
    stop(paste("Missing required options:", paste(missing, collapse=', ')))
}

# Check file inputs are valid
for (file_input in c('deseq2_results')){
    if (is.null(opt[[file_input]])) {
        stop(paste("Please provide", file_input), call. = FALSE)
    }

    if (! file.exists(opt[[file_input]])){
        stop(paste0('Value of ', file_input, ': ', opt[[file_input]], ' is not a valid file'))
    }
}

# Convert params to defaults if required
if (startsWith(opt$dsq_p_thresh, "!")) { opt$dsq_p_thresh <- 1 }
if (startsWith(opt$ontology, "!")) { opt$ontology <- "mf" }
if (startsWith(opt$p_adjust_method, "!")) { opt$p_adjust_method <- "BH" }
if (startsWith(opt$min_gset_size, "!")) { opt$min_gset_size <- 10 }
if (startsWith(opt$max_gset_size, "!")) { opt$max_gset_size <- 500 }
if (startsWith(opt$gsea_p_cutoff, "!")) { opt$gsea_p_cutoff <- 0.05 }
if (startsWith(opt$gsea_q_cutoff, "!")) { opt$gsea_q_cutoff <- 0.05 }
if (startsWith(opt$pathway_count, "!")) { opt$pathway_count <- 10 }
if (startsWith(opt$stats_metric, "!")) { opt$stats_metric <- "p.adjust" }

print(opt)

################################################
################################################
## Finish loading libraries                   ##
################################################
################################################

library(geneset)
library(genekitr)
# library(patchwork)

################################################
################################################
## Load and prepare data                      ##
################################################
################################################

# Load results table
results <- read_delim_flexible(
    file = opt$deseq2_results,
    header = TRUE
)

# Filter table based on p-value
results <- subset(results, padj < opt$dsq_p_thresh)

# Sort by descending logfold change
results <- results[order(results$log2FoldChange, decreasing = TRUE),]

# Extract named vector of genes and fold change
gene_list <- results$log2FoldChange
names(gene_list) <- results$gene_id

################################################
################################################
## Generate genekitr                          ##
################################################
################################################

gs <- geneset::getGO(org=opt$organism, ont=opt$ontology)
gse <- genGSEA(
    genelist=gene_list,
    geneset=gs,
    padj_method=opt$p_adjust_method,
    min_gset_size=opt$min_gset_size,
    max_gset_size=opt$max_gset_size,
    p_cutoff=opt$gsea_p_cutoff,
    q_cutoff=opt$gsea_q_cutoff
)

ora <- genORA(
    results$gene_id,
    geneset=gs,
    padj_method=opt$p_adjust_method,
    min_gset_size=opt$min_gset_size,
    max_gset_size=opt$max_gset_size,
    p_cutoff=opt$gsea_p_cutoff,
    q_cutoff=opt$gsea_q_cutoff
)

################################################
################################################
## Output Data                                ##
################################################
################################################

genekitr::expoSheet(data_list = gse,
                    data_name = names(gse),
                    filename = paste(opt$prefix, ".genekitr_gsea_result.xlsx"),
                    dir = "./")

genekitr::expoSheet(data_list = ora,
                    data_name = names(gse),
                    filename = paste(opt$prefix, ".genekitr_ora_result.xlsx"),
                    dir = "./")

################################################
################################################
## Output Plots                               ##
################################################
################################################

gse$gsea_df$Hs_MF_ID <- gse$gsea_df$Description

# Classic pathway plot - TODO non-functional
# png(
#     file = paste(opt$prefix, '.gsea.pathway.png'),
#     width = opt$plot_width,
#     height = opt$plot_height,
#     res = opt$plot_res,
#     pointsize = opt$plot_point_size
# )
# plotGSEA(gse, plot_type = "classic")
# dev.off()

# Volcano plot
png(
    file = paste(opt$prefix, '.gsea.volcano.png'),
    width = opt$plot_width,
    height = opt$plot_height,
    res = opt$plot_res
)
plotGSEA(gse, plot_type = "volcano", show_pathway = 5, stats_metric = opt$stats_metric)
dev.off()

# Multi-pathway plot
png(
    file = paste(opt$prefix, '.gsea.mpathway.png'),
    width = opt$plot_width,
    height = opt$plot_height,
    res = opt$plot_res
)
plotGSEA(gse, plot_type = "fgsea", show_pathway = 5, stats_metric = opt$stats_metric)
dev.off()

# Ridge plot
png(
    file = paste(opt$prefix, '.gsea.ridge.png'),
    width = opt$plot_width,
    height = opt$plot_height,
    res = opt$plot_res
)
plotGSEA(gse, plot_type = "ridge", show_pathway = opt$pathway_count, stats_metric = opt$stats_metric)
dev.off()

# Bar plot
png(
    file = paste(opt$prefix, '.gsea.bar.png'),
    width = opt$plot_width,
    height = opt$plot_height,
    res = opt$plot_res
)
plotGSEA(gse, plot_type = "bar", show_pathway = opt$pathway_count, stats_metric = opt$stats_metric)
dev.off()

# Dot
png(
    file = paste(opt$prefix, '.gsea.dot.png'),
    width = opt$plot_width,
    height = opt$plot_height,
    res = opt$plot_res
)
plotEnrich(gse,
  plot_type = "dot",
  stats_metric = opt$stats_metric
)
dev.off()

################################################
################################################
## R SESSION INFO                             ##
################################################
################################################

# sink(paste(output_prefix, "R_sessionInfo.log", sep = '.'))
# print(sessionInfo())
# sink()

################################################
################################################
## VERSIONS FILE                              ##
################################################
################################################

# r.version <- strsplit(version[['version.string']], ' ')[[1]][3]
# deseq2.version <- as.character(packageVersion('DESeq2'))

# writeLines(
#     c(
#         '"${task.process}":',
#         paste('    r-base:', r.version),
#         paste('    bioconductor-deseq2:', deseq2.version)
#     ),
# 'versions.yml')

################################################
################################################
################################################
################################################
