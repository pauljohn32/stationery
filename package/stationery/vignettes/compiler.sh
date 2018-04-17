
## Paul Johnson
## 2018-02-22

## Rebuilds Vignettes:
## For LyX files, must extract to Rnw

lyx -e sweave instructions-rnw2pdf-slides-sweave.lyx
./rnw2pdf.sh --engine='"Sweave"' --tangle=FALSE instructions-rnw2pdf-slides-sweave.Rnw

lyx -e sweave instructions-rnw2pdf-report-sweave.lyx
./rnw2pdf.sh --engine='"Sweave"' --tangle=FALSE instructions-rnw2pdf-report-sweave.Rnw

lyx -e knitr instructions-rnw2pdf-report-knit.lyx
./rnw2pdf.sh --tangle=FALSE --engine='"knitr"' instructions-rnw2pdf-report-knit.Rnw

lyx -e sweave instructions-rnw2pdf-guide-sweave.lyx
./rnw2pdf.sh --engine='"Sweave"' --tangle=FALSE instructions-rnw2pdf-guide-sweave.Rnw

lyx -e knitr instructions-rnw2pdf-guide-knit.lyx
./rnw2pdf.sh --tangle=FALSE --engine='"knitr"' --keep_tex=FALSE instructions-rnw2pdf-guide-knit.Rnw


./rmd2pdf.sh --template='"theme/report-boilerplate.tex"' --tangle=FALSE instructions-rmd2pdf-report.Rmd

./rmd2pdf.sh --template='"theme/guide-boilerplate.tex"' --tangle=FALSE instructions-rmd2pdf-guide.Rmd


./rmd2pdf.sh --template='"theme/report-boilerplate.tex"' --purl=FALSE Rmarkdown.Rmd

./rmd2pdf.sh --template='"theme/guide-boilerplate.tex"' --purl=FALSE code_chunks.Rmd


lyx -e sweave stationery.lyx
./rnw2pdf.sh --engine='"Sweave"' --tangle=FALSE stationery.Rnw

./rmd2html.sh --template='"theme/guide-boilerplate.html"' --purl=FALSE HTML_special_features.Rmd

rm -rf Rplots*.pdf
cleanLatex.sh . 

# % \VignetteIndexEntry{rnw2pdf-slides-sweave}
# % \VignetteEngine{Sweave}
# % \VignetteBuilder{stationery::rnw2pdf}



# vignette: >
#     %\VignetteIndexEntry{Rmarkdown_Overview}
#     %\VignetteEngine{knitr::rmarkdown}
#     %\VignetteEncoding{UTF-8}
