
##' A CRMDA-styling of the rendering from Rmd to HTML for Guides
##'
##' This is a very simple wrapper around the rmarkdown::render function.
##' It makes sure that the style sheet we want to use is applied to the data.
##'
##' Running this will be the same as running the rmd2html.sh script
##' within the directory.
##' @param fn A file name. If not specified, then all Rmd documents
##'     within directory are rendered.
##' @param wd A working directory name. If not specified, then the
##'     current working directory from R will be used.
##' @param verbose The opposite of render(quiet = TRUE). Shows compile
##'     commentary and pandoc command. Can be informative!
##' @importFrom rmarkdown render
##' @return A vector of output file names
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @export
##' @examples
##' ## put some file name in
##' fp <- system.file("extdata/rmd2html-guide", "guide-template.Rmd", package = "crmda")
##' tdir <- tempdir()
##' file.copy(fp, to = tdir, copy.mode = TRUE, copy.date = TRUE)
##' wd.orig <- getwd()
##' setwd(tdir)
##' of <- rmd2html(fp)
##' browseURL(of[1])
##' setwd(wd.orig)
rmd2html <- function(fn = NULL, wd = NULL, verbose = FALSE) {
    if (!is.null(wd)){
        wd.orig <- getwd()
        setwd(wd)
    }
    
    
    if (is.null(fn)) {
        cat("Will render all *.Rmd files in current working directory\n")
        fn <- list.files(pattern="Rmd")
    }    
    ## render(fn, html_document(css = system.file("extdata/theme", "kutils.css", package = "crmda")), quiet = !verbose)

    res <- sapply(fn, rmarkdown::render, rmarkdown::html_document(css = system.file("extdata/theme", "kutils.css", package = "crmda")), quiet = !verbose)

    if (!is.null(wd)){
        setwd(wd.orig)
    }
    res
}


##' Convert an Rnw or lyx file to pdf
##'
##' Documents saved with suffic ".lyx" or ".Rnw" will be
##' converted.  Note it is very important to specify the
##' engine correctly, this can be either "Sweave" or "knitr".
##' 
##' @param fn should end in either ".Rnw" or ".lyx"
##' @param wd Directory in which the file to be converted
##'     exists. Leave NULL default if is in current working directory.
##' @param engine knitr or Sweave
##' @param verbose if FALSE, the knitr quiet is set as TRUE
##' @return NULL
##' @export
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @importFrom knitr knit2pdf
##' @importFrom knitr knit
##' @importFrom utils Sweave
##' @examples 
##' tmpdir <- tempdir()
##' fdir <- system.file("extdata/rnw2pdf-guide-sweave", "", package = "crmda")
##' wdir <- file.path(tmpdir, basename(fdir))
##' dir.create(wdir, recursive = TRUE)
##' file.copy(from = fdir, to = tmpdir, recursive = TRUE)
##' rnw2pdf("guide-template.lyx", wd = wdir, engine = "Sweave")
##' tmpdir <- paste0(tmpdir, "-2")
##' wdir <- file.path(tmpdir, basename(fdir))
##' dir.create(wdir, recursive = TRUE)
##' file.copy(from = fdir, to = tmpdir, recursive = TRUE)
##' rnw2pdf("guide-template.Rnw", wd = wdir, engine = "Sweave")
##' 
rnw2pdf <- function(fn = NULL, wd = NULL, engine = "knitr", verbose = FALSE) {
    if (!is.null(wd)) {
        wd.orig <- getwd()
        setwd(wd)
    }
    
    if (is.null(fn)) {
        cat("Will render all *.Rnw files in current working directory\n")
        fn <- list.files(pattern="Rnw")
    }    
   
    compileme <- function(x, verbose) {
        if (length(grep("\\.lyx$", tolower(x)))){
            if (tolower(engine) == "knitr"){
                system(paste("lyx -e knitr ", x))
            } else {
                system(paste("lyx -e sweave ", x))
            }
            system(paste("lyx -e pdf2 ", x))
            x <- gsub("\\.lyx$", ".Rnw", x)
            fnpdf <- gsub("\\.lyx$", ".pdf", x, ignore.case = TRUE)
        } else if (length(grep("\\.rnw$", tolower(x)))) {
            if (tolower(engine) == "knitr"){
                knitr::knit(x, quiet = !verbose, tangle = TRUE)
                fnpdf <- knitr::knit2pdf(x, quiet = !verbose)
            } else {
                Sweave(x)
                tools::texi2pdf(gsub("\\.Rnw$", ".tex", x, ignore.case = TRUE), texi2dvi = "texi2pdf")
                fnpdf <- gsub("\\.Rnw$", ".pdf", x, ignore.case = TRUE)
            }
        }
        
        if (file.exists(fnpdf)){
            return(fnpdf)
        } else {
            return("Failed")
        }
    }

    res <- list()
    for(i in fn){
        res[[i]] <- compileme(i, verbose = verbose)
    }
    
    if (!is.null(wd)){
        setwd(wd.orig)
    }
    res
}


##' Can be named as an output theme, which knitr will understand
##'
##' Insert output: crmda::crmda_guide.
##'
##' For additional embellishments, see \url{http://rmarkdown.rstudio.com/developer_custom_formats.html}
##' @param toc Table of Contents flag
##' @param verbose Verbose output
##' @return rmarkdown function
##' ##' @export
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @importFrom rmarkdown html_document
crmda_guide <- function(toc = FALSE, verbose = FALSE){
    css <- system.file("extdata/theme/kutils.css", package = "crmda") 
    rmarkdown::html_document(toc = toc, css = css, quiet = !verbose)
}
