library(readr)
library(dplyr)
library(geepack)
library(ggplot2)
library(cowplot)

source("input.r")
source("gee.r")
source("ggp_themes.r")
source("plot.r")

main <- function() {

    ## set project variables
    pvars <- list()
    pvars$proj_dir <- "/home/chd5n/projects/esophagus/"
    pvars$data_dir <- paste0(pvars$proj_dir, "data/")
    pvars$data_name <- paste0(pvars$data_dir, "negatives.tsv")

    ## parse data
    dfs <- get_data(pvars$data_name)
    fits <- lapply(dfs, fit_gee)
    sums <- lapply(fits, parse_gee)
    dfs2 <- lapply(dfs, summarise_data)

    ## make plots
    ggp <- lapply(dfs, ggp_box)
    ggp2 <- lapply(dfs2, ggp_box)

    target <- paste0(pvars$proj_dir, "negatives.pdf")
    ggp_write(ggp, target, nrow=3, ncol=4, ht=9, wd=12)
    target <- paste0(pvars$proj_dir, "negatives2.pdf")
    ggp_write(ggp2, target, nrow=3, ncol=4, ht=9, wd=12)
    invisible(
        lapply(seq.int(from=1, to=length(ggp), by=2), FUN <- function(i) {
            title <- sub(" ", "_", tolower(ggp[[i]]$labels$title))
            target <- paste0(pvars$proj_dir, "neg_", title, ".pdf")
            ggp_write(ggp[i:(i + 1)], target)
        })
    )
    invisible(
        lapply(seq.int(from=1, to=length(ggp2), by=2), FUN <- function(i) {
            title <- sub(" ", "_", tolower(ggp2[[i]]$labels$title))
            target <- paste0(pvars$proj_dir, "neg2_", title, ".pdf")
            ggp_write(ggp2[i:(i + 1)], target)
        })
    )

    ## make annotated plots
    # ggp <- lapply(seq_len(length(dfs)), FUN <- function(i) {
    #     if (length(levels(factor(dfs[[i]]$allele))) > 2) {
    #         ggp <- ggp_box_triallele(dfs[[i]], sums[[i]])
    #     } else {
    #         ggp <- ggp_box_biallele(dfs[[i]], sums[[i]])
    #     }
    #     return(ggp)
    # })
}

main()
