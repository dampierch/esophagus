## to be sourced from main analysis script

gee_multi_plate <- function(data, levels) {
    fit <- geeglm(
        rel_lum ~ factor(allele, levels=levels) + factor(plate_id),
        data=data,
        id=factor(plate_id):factor(clone_id),
        family=gaussian(link="log"),
        corstr="exchangeable",
        std.err="san.se",
        zcor=NULL
    )
    return(fit)
}

gee_single_plate <- function(data, levels) {
    fit <- geeglm(
        rel_lum ~ factor(allele, levels=levels),
        data=data,
        id=factor(clone_id),
        family=gaussian(link="log"),
        corstr="exchangeable",
        std.err="san.se",
        zcor=NULL
    )
    return(fit)
}

fit_gee <- function(data) {
    if (length(levels(factor(data$plate_id))) > 1) {
        cat("testing multi plate experiment\n")
        if (length(levels(factor(data$allele))) == 3) {
            cat("testing tri alleleic site\n")
            levs <- levels(factor(data$allele))
            fit1 <- gee_multi_plate(data, levs)
            fit2 <- gee_multi_plate(data, rev(levs))
            fit <- setNames(list(fit1, fit2), c("default", "reversed"))
        } else {
            cat("testing bi alleleic site\n")
            levs <- levels(factor(data$allele))
            fit <- gee_multi_plate(data, levs)
        }
    } else {
        cat("testing single plate experiment\n")
        if (length(levels(factor(data$allele))) == 3) {
            cat("testing tri alleleic site\n")
            levs <- levels(factor(data$allele))
            fit1 <- gee_single_plate(data, levs)
            fit2 <- gee_single_plate(data, rev(levs))
            fit <- setNames(list(fit1, fit2), c("default", "reversed"))
        } else {
            cat("testing bi alleleic site\n")
            levs <- levels(factor(data$allele))
            fit <- gee_single_plate(data, levs)
        }
    }
    return(fit)
}

parse_gee <- function(fit) {
    if (class(fit)[1] == "list") {
        cat("extracting coefficient summary for tri alleleic site\n")
        df <- lapply(fit, FUN <- function(x) {
            df <- summary(x)$coefficients
            df <- df[2:nrow(df), "Pr(>|W|)", drop=FALSE]
            return(df)
        })
    } else {
        cat("extracting coefficient summary for bi alleleic site\n")
        df <- summary(fit)$coefficients
        df <- df[2:nrow(df), "Pr(>|W|)", drop=FALSE]
    }
    return(df)
}
