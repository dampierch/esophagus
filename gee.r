## to be sourced from main analysis script

fit_gee <- function(data) {
    if (length(levels(factor(data$plate_id))) > 1) {
        fit <- geeglm(
            rel_lum ~ factor(allele) + factor(plate_id),
            data=data,
            id=factor(plate_id):factor(clone_id),
            family=gaussian(link="log"),
            corstr="exchangeable",
            std.err="san.se",
            zcor=NULL
        )
    } else {
        fit <- geeglm(
            rel_lum ~ factor(allele),
            data=data,
            id=factor(clone_id),
            family=gaussian(link="log"),
            corstr="exchangeable",
            std.err="san.se",
            zcor=NULL
        )
    }
    return(fit)
}

