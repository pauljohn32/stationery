
##' A CRMDA-styling of the rendering from Rmd to HTML for Guides
##'
##' This is a very simple wrapper around the rmarkdown::render function.
##' It makes sure that the style sheet we want to use is applied to the data.
##'
##' Running this will be the same as running the rmd2html.sh script within
##' the directory.
##' @param fn A file name. If not specified, then all Rmd documents within directory are rendered.
##' @param wd A working directory name. If not specified, then the current working directory from R will be used.
##' @param verbose The opposite of render(quiet = TRUE). Shows compile commentary and pandoc command. Can be informative!
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


