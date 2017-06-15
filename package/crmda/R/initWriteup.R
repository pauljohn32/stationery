
##' Create skeleton for a report or guide. 
##'
##' The installed package includes a set of folders with document
##' templates. Starting a new document should be as simple as copying
##' one of those folders into one's current working directory and
##' then editing the files. The document skeleton is created in a
##' directory that will be created if it does not exist.
##'
##' The directories we currently provide are
##' 1) rmd2html-guide 2) rmd2pdf-report
##' 3) rnw2pdf-guide-knit 4) rnw2pdf-guide-sweave
##' 5) rnw2pdf-report-knit 6) rnw2pdf-report-sweave
##' 7) tex2pdf-report
##'
##' Each selection offers a self-contained working document and enough
##' information to compile that document.
##'
##' @section Report or Guide?: As one can see, documents can be prepared in markdown
##'     "rmd", R noweb (either with Sweave or knitr style), or simply
##'     as a LaTeX document that does not interact with R at all.  The
##'     allowed components in a report or guide depend on whether the
##'     eventual output is HTML or PDF. That's why we need to have so
##'     many mix-and match combinations of document types and report
##'     types.
##' \cr\cr
##' We may have slide templates as well, at some point in future
##'
##' The examples demonstrate all three of these scenarios.
##' @param type One of these: \code{c("rmd2html-guide",
##'     "rmd2pdf-report", "rnw2pdf-guide-knit", "rnw2pdf-guide-sweave",
##'     "rnw2pdf-report-knit", "rnw2pdf-report-sweave",
##'     "tex2pdf-report")}
##' @param dir Type "." for current working directory.
##' Default is a new directory named "writeup"
##' @importFrom kutils initProject
##' @export
##' @return The normalized path of the new directory
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @examples
##' tdir <- tempdir()
##' wd.orig <- getwd()
##' setwd(tdir)
##' cat("The Temporary Directory is:\n ", tdir, "\n")
##' cat("We launch a new writeup there\n")
##' 
##' kutils::initProject(type = "rmd2html-guide", dir = "writeup/rmd1")
##' list.files()
##' initWriteup(type = "rnw2pdf-guide-knit", dir = "writeup/rnw")
##' list.files("writeup/rnw")
##' initWriteup(type = "rmd2pdf-report", dir = "writeup/rmd2")
##' list.files("writeup/rmd2")
##' initWriteup(type = "rmd2html-guide", dir = "writeup/rmd3")
##' list.files("writeup/rmd3")
##'
##' setwd(wd.orig)
initWriteup <- function(type = NULL,
                        dir = "writeup")
{
    wd <- getwd()
   
    ## Only create dir if dir NULL
    if (!dir.exists(dir)){
        dir.create(dir, recursive = TRUE)
    }

    dir.path <- system.file("extdata", type, package = "crmda")
    
    if (dir.path == "") {
        messg <- paste0("type", type, "not found")
        cat(messg)
        return(invisible(NULL))
    }

    file.copy(dir.path, to = dir, recursive = TRUE, copy.date = TRUE) 
    normalizePath(dir)
}

    
