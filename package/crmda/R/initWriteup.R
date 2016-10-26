
##' Create skeleton for a report. 
##'
##' The examples demonstrate all three of these scenarios.
##' @param input Default is "Rmd", others are "Rnw", and "tex" (tex
##'     includes "lyx" and "tex")
##' @param output "pdf" or "html"
##' @param render "Sweave" or "knit". The choice between "Sweave" and
##'     "knit" only exists for documents with input = "Rnw".  If input =
##'     "Rmd", this argument is always set as "knit".
##' @param type Default = "report". Also, "guide" is allowed
##' @param dirname Working data directory, default as "writeup"
##' @importFrom kutils initProject
##' @export
##' @return The normalized path of the directory that is created
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @examples
##'
##' tdir <- tempdir()
##' setwd(tdir)
##' cat("The Temporary Directory is:\n ", tdir, "\n")
##' cat("We launch project there in which writeup folder exists\n")
##' 
##' kutils::initProject()
##' list.files()
##' setwd("writeup")
##' 
##' initWriteup(input = "Rmd", output = "pdf", render = "knit",
##'               dirname = "rmd2pdf-report-knit")
##'
##' initWriteup(input = "Rmd", output = "html", type = "guide",
##'              render = "knit", dirname = "rmd2pdf-guide-knit")
##'
##' initWriteup(input = "Rnw", output = "pdf", type = "guide",
##'             
##' 
##' ## Should fail, because there is no html report
##' initWriteup(input = "Rmd", output = "html", dirname = "rmd2html")

initWriteup <- function(input = "Rmd",
                        output = "pdf",
                        render = "Sweave",
                        type = "report",
                        dirname = "writeup")
{
    wd <- getwd()

    if (missing(input) || tolower(input) == "rmd") render = "knit"
    
    ## Only create dir if dir NULL
    if (!dir.exists(dirname)){
        dir.create(dirname, recursive = TRUE)
    }

    extdir <- tolower(paste0("extdata/", input, 2, output))
    extdir <- paste0(extdir, "-", type)

    ## Only need -sweave or -knit if document is rnw
    if((tolower(input) == "rnw")){
        extdir <- paste0(extdir, "-", type, "-", tolower(render))
    }
        
    dir.path <- system.file(extdir, ".",   package = "crmda")
    
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

   
    file.copy(file.path(dir.path),  to = dirname, recursive = TRUE, copy.date = TRUE) 
    normalizePath(dirname)
}

    
