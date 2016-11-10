
##' Create skeleton for a report or guide. 
##'
##' The installed package includes a set of folders with document
##' templates. Starting a new document should be as simple as copying
##' one of those folders into one's current working directory and
##' then editing the files. The document skeleton is created in a
##' directory that will be created if it does not exist.
##'
##' The directories we currently provide are 1) rmd2html-guide 2)
##' rmd2pdf-report 3) rnw2pdf-guide-knit 4) rnw2pdf-guide-sweave 5)
##' rnw2pdf-report-knit 6) rnw2pdf-report-sweave 7)
##' tex2pdf-report. Our goal is to make sure each one offers a
##' self-contained working document and enough information to compile
##' that document. We've already got a function named \code{rmd2html}
##' that can compile guide documents.  Compilers for the other ones
##' exist, but are not atomated yet.
##'
##' @section As one can see, documents can be prepared in markdown "rmd", R
##' noweb (either with Sweave or knitr style), or simply as a LaTeX
##' document that does not interact with R at all.  The allowed
##' components in a report or guide depend on whether the eventual
##' output is HTML or PDF. That's why we need to have so many mix-and
##' match combinations of document types and report types.
##'
##' @section We believe writeups will fall into two types, either "guide" or
##' "report". The difference between these two features is summarized
##' in a slide show that is included with the package in the vignettes
##' folder.
##'
##' The examples demonstrate all three of these scenarios.
##' @param folderin Specify either \code{folderin} or the 4-tuple of
##' variables, \code{input} \code{output} \code{render} \code{type}. Choices
##' allowed for this are c("rmd2html-guide", "rmd2pdf-report",
##' "rnw2pdf-guide-knit", "rnw2pdf-guide-sweave", "rnw2pdf-report-knit",
##' "rnw2pdf-report-sweave", "tex2pdf-report")
##' @param input Default is "Rmd", others are "Rnw", and "tex" (tex
##'     includes "lyx" and "tex")
##' @param output "pdf" or "html"
##' @param render "Sweave" or "knit". The choice between "Sweave" and
##'     "knit" only exists for documents with input = "Rnw".  If input =
##'     "Rmd", this argument is always set as "knit".
##' @param type Default = "report". Also, "guide" is allowed
##' @param newdir Working data directory, default as "writeup"
##' @importFrom kutils initProject
##' @export
##' @return The normalized path of the directory that is created
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @examples
##' tdir <- tempdir()
##' wd.orig <- getwd()
##' setwd(tdir)
##' cat("The Temporary Directory is:\n ", tdir, "\n")
##' cat("We launch project there in which writeup folder exists\n")
##' 
##' kutils::initProject()
##' list.files()
##' setwd("writeup")
##'
##' ## Notice: some will fail because we don't have templates
##' ## for them yet
##' initWriteup(input = "Rmd", output = "pdf", type = "report",
##'               newdir = "rmd2pdf-report-knit")
##'
##' initWriteup(input = "Rmd", output = "html", type = "guide",
##'             newdir = "rmd2html-guide-knit")
##' ## No need specify render for "Rmd" docs, only knit is possible
##' 
##' initWriteup(input = "Rnw", output = "pdf", type = "guide",
##'              render = "Sweave", newdir = "rnw2pdf-guide-sweave")
##'
##' initWriteup(input = "Rnw", output = "pdf", type = "guide",
##'              render = "Sweave", newdir = "rnw2pdf-guide-sweave")
##'
##' initWriteup(input = "Rnw", output = "pdf", type = "report",
##'              render = "knit", newdir = "rnw2pdf-report-knit")
##' 
##' ## Should fail, because there is no html report (never will be)
##' initWriteup(input = "Rmd", output = "html", newdir = "rmd2html")
##'
##' list.files()
##' setwd(wd.orig)
initWriteup <- function(folderin = NULL,
                        input = "Rmd",
                        output = "pdf",
                        render = "Sweave",
                        type = "report",
                        newdir = "writeup")
{
    wd <- getwd()

    if (missing(input) || tolower(input) == "rmd") render = "knit"
    
    ## Only create dir if dir NULL
    if (!dir.exists(newdir)){
        dir.create(newdir, recursive = TRUE)
    }

    if (is.null(folderin)){
        folderin <- tolower(paste0("extdata/", input, "2", output))
        folderin <- paste0(folderin, "-", type)
        
        ## Only need -sweave or -knit if document is rnw
        if((tolower(input) == "rnw")){
            folderin <- paste0(folderin, "-", type, "-", tolower(render))
        }
    }
    folderin <- paste0("extdata/", folderin)
    dir.path <- system.file(folderin, ".",   package = "crmda")
    
    if (dir.path == "") {
        messg <- paste0("Sorry, the combination of", " input =\"", input,
                        "\", output =\"", output,
                        "\", \ntype = \"", type,
                        "\", render = \"", render,
                       "\"\ndoes not match any of the writeup-types we have prepared.\n",
                       "Lets check the crmda package install directory to see \nwhat types exist\n")
        cat(messg)
        doctypes <- system.file("extdata", package = "crmda")
        cat(paste(list.files(doctypes), collapse = "\n"))
        return(invisible(NULL))
    }

   
    file.copy(file.path(dir.path),  to = newdir, recursive = TRUE, copy.date = TRUE) 
    normalizePath(newdir)
}

    
