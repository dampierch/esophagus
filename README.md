# Enhancers Modulating Esophageal Cancer Risk

This repository stores luciferase reporter assay analysis code.

## Data

Data is not currently pushed to GitHub but will be once published.
Collected from OE19 and OE33 esophageal adenocarcinoma cell lines.
Each putative enhancer element tested in forward and reverse orientations.
Each allele cloned three times.
Each clone measured three times.
Experiment performed one time for negative results and three times for positive results.

## Code

Allele specific enhancer activity is tested using generalized estimating equations to account for the expected correlation between different measurements of the same clones and repeated experiments.

## Figure Legends

For positive results, each experiment is represented by a different shape.
Each shape includes three clones tested and measured in three wells each.
For negative results, only one experiment was performed.
Each grey point represents the relative luminescence of the tested clone compared to a negative control (i.e. relative luminescence).
Each red point represents the mean of all wells for the given allele or haplotype.
Boxes represent the interquartile range.
Whiskers extend to 1.5 times the interquartile range.
The breaks of the y-axis are log2 scaled when more than a single experiment is represented along that axis, which is only true in the case of positive results.
