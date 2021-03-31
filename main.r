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
    pvars <- list()
    pvars$dir <- "/home/chd5n/projects/esophagus/"
    pvars$data <- paste0(pvars$dir, "negatives.tsv")

    dfs <- get_data(pvars$data)
    fits <- lapply(dfs, fit_gee)
    sums <- lapply(fits, FUN <- function(fit) {
        df <- summary(fit)$coefficients
        df <- df[2:nrow(df), "Pr(>|W|)", drop=FALSE]
        return(df)
    })
    ggp <- lapply(seq_len(length(dfs)), FUN <- function(i) {
        if (length(levels(factor(dfs[[i]]$allele))) > 2) {
            ggp <- ggp_box_triallele(dfs[[i]], sums[[i]])
        } else {
            ggp <- ggp_box_biallele(dfs[[i]], sums[[i]])
        }
        return(ggp)
    })
    cwp <- plot_grid(plotlist=ggp, nrow=3, ncol=4)
    target <- paste0(pvars$dir, "negatives.pdf")
    pdf(target, height=9, width=12)
    print(cwp)
    dev.off()
    cat("plot written to", target, "\n")
}
