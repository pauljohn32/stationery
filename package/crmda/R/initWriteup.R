
##' Create skeleton for a report. 
##'
##' The examples demonstrate all three of these scenarios.
##' @param input "Rnw" or "Rmd"
##' @param output "pdf" or "html"
##' @param render "Sweave" or "knit". If input = "Rmd", this argument is always set as "knit".
##' @param type Default = "report". Also, "guide" is allowed 
##' @param dirname Working data directory, default as "writeup"
##' @importFrom kutils initProject
##' @export
##' @return The normalized path of the directory that is created
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @examples
##' kutils::initProject()
##' 
##' setwd("writeup")
##' initWriteup(input = "Rmd", output = "html", dirname = "rmd2html")
##' 
##' initWriteup(input = "Rmd", output = "pdf", render = "knit",
##'               dirname = "rmd2pdf-knit")
##' 
initWriteup <- function(input = "Rnw",
                        output = "pdf",
                        render = "Sweave",
                        type = "report",
                        dirname = "writeup")
{
    wd <- getwd()
    
    ## Only create dir if dir NULL
    if (!dir.exists(dirname)){
        dir.create(dirname, recursive = TRUE)
    }

    extdir <- tolower(paste0("extdata/", input, 2, output))
    extdir <- paste0(extdir, "-", type)

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
        cat(list.files(doctypes))
        return(invisible(NULL))
    }

   
    file.copy(file.path(dir.path),  to = dirname, recursive = TRUE, copy.date = TRUE) 
    normalizePath(dirname)
}

    
