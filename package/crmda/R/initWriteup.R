
##' Create skeleton for a report or guide. 
##'
##' The installed package includes a set of folders with document
##' templates. \code{initWriteup} is simply an automated way to copy
##' the template folder and skeleton document file into a new
##' directory.
##' \cr
##' \cr
##' The current formats are:
##' 1) rmd2html-guide  2) rmd2pdf-report
##' 3) rnw2pdf-guide-sweave  4) rnw2pdf-report-sweave  
##' 5) rmd2pdf-guide   6) rnw2pdf-guide-knit
##' 7) rnw2pdf-report-knit 7) rnw2pdf-slides-sweave
##' \cr
##' \cr
##' ##' The names represent the "from" format (rmd or rnw), the "to"
##' format (html or pdf), the document type (guide or report), and the
##' chunck processing program (Sweave or knitr).
##' \cr
##' \cr
##' Each selection offers a self-contained working document and enough
##' information to compile that document. It also includes a shell script
##' that can compile the document.
##'
##' @section Details:
##'
##' The examples demonstrate all of the mix-and-match combinations of
##' input document formats, output formats, and document types. The issues
##' involved are more fully explained in the vignettes provided with the
##' package, but a nutshell summary would be as follows.
##' 
##' Report or Guide?
##' 
##' In our terminology, a guide is a document that includes "raw" code
##' examples and possibly output. A guide is intended for
##' training/teaching purposes, it might be offered on
##' http://crmda.ku.edu/guides. In contrast, a report generally
##' will now include "raw" code and only very rarely will it have
##' raw output.  Calculations should create tables and plots that
##' are inserted as (in LaTeX, floating) tables and figures.
##'
##' Markdown ("*.Rmd") or Noweb ("*.Rnw")?
##' 
##' Documents can be prepared in markdown "Rmd" or R noweb Rnw. Either
##' type of document can include code chunks. For creating HTML
##' output, markdown is perhaps the most workable format. For creating
##' PDF output, the noweb document format is better. When PDF output
##' is desired, a markdown document must be converted to tex and then to
##' PDF. Some LaTeX features are lost in that process, but they are
##' not lost if we prepare the document in a noweb format (which *is*
##' a LaTeX file).  The details are discussed in the vignettes available
##' with this package.
##' 
##' PDF or HTML?
##' 
##' The allowed components in a report or guide depend on whether the
##' eventual output is HTML or PDF.  Many features intended for PDF
##' outpu will not work if the backend is changed to HTML.  The
##' converse is also true.  While this may change in the future, at
##' the current time, only the most basic document which does not
##' include most of the features that we truly need will be compatible
##' with both PDF and HTML output.  That's why we need to have so many
##' mix-and match combinations of document types and output formats.
##'
##' 
##'
##' We may have slide templates as well, at some point in future.
##'
##' 
##' @param type One of these: \code{c("rmd2html-guide",
##'     "rmd2pdf-report", "rnw2pdf-guide-knit",
##'     "rnw2pdf-guide-sweave", "rmd2pdf-guide",
##'     "rnw2pdf-report-knit", "rnw2pdf-report-sweave",
##'     "rnw2pdf-slides-sweave")}
##' @param dir Type "." for current working directory.  Default is a
##'     new directory named "writeup"
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
##' ## create with default directory "writeup"
##' initWriteup(type = "rmd2html-guide")
##' list.files("writeup", recursive = TRUE)
##' ## This will create on example of each type of document
##' ## in a folder named "todaytest"
##' doctype <- c("rmd2html-guide", "rmd2pdf-report",
##'           "rnw2pdf-guide-knit", "rnw2pdf-guide-sweave",
##'           "rmd2pdf-guide", "rnw2pdf-report-knit",
##'           "rnw2pdf-report-sweave", "rnw2pdf-slides-sweave")
##' folders <- vapply(doctype, initWriteup, dir = "todaytest", character(1))
##' folders
##' list.files("todaytest", recursive = TRUE)
##' setwd(wd.orig)
##'
initWriteup <- function(type = NULL,
                        dir = "writeup")
{
    wd <- getwd()
    on.exit(setwd(wd))
    dir <- file.path(dir, type)
    ## Only create dir if dir NULL
    if (!dir.exists(dir)){
        dir.create(dir, recursive = TRUE)
    }

    dir.path <- system.file("rmarkdown/templates/", type, "skeleton", package = "crmda")
    
    if (dir.path == "") {
        messg <- paste0("type", type, "not found")
        cat(messg)
        return(invisible(NULL))
    }

    file.copy(from = Sys.glob(paste0(dir.path, "/*")), to = dir,
              recursive = TRUE, copy.date = TRUE) 
    normalizePath(dir)
}

    
