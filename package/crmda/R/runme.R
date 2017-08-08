
##' A CRMDA-styling of the rendering from Rmd to HTML for Guides
##'
##' This is a very simple wrapper around the rmarkdown::render function.
##' It makes sure that the style sheet we want to use is applied to the data.
##'
##' Running this will be the same as running the rmd2html.sh script
##' within the directory.
##' @param fn A file name. If not specified, then all Rmd documents
##'     within directory are rendered.
##' @param wd A working directory name of the Rmd file. If not
##'     specified, then the current working directory from R will be
##'     used.
##' @param verbose The opposite of render(quiet = TRUE). Shows compile
##'     commentary and pandoc command. Can be informative!
##' @param ... Arguments that will be passed to render and
##'     html_document. The defaults set within the
##'     \code{rmarkdown::render} and \code{rmarkdown::html_documents}
##'     will be followed unless the user changes them with this
##'     argument, except that we assume for \code{html_document()}
##'     that css = "kutils.css" and toc = TRUE.  These arguments
##'     intended for \code{render()} are allowed: c("output_file",
##'     "output_dir", "output_options", "intermediates_dir",
##'     "knit_root_dir", "runtime", "clean", "params", "knit_meta",
##'     "envir", "run_pandoc", "quiet", "encoding") .  These arguments
##'     intended for html_document are allowed: \code{c("toc",
##'     "toc_depth", "toc_float", "number_sections", "section_divs",
##'     "fig_width", "fig_height", "fig_retina", "fig_caption", "dev",
##'     "df_print", "code_folding", "code_download", "smart",
##'     "self_contained", "theme", "highlight", "mathjax", "template",
##'     "extra_dependencies", "css", "includes", "keep_md", "lib_dir",
##'     "md_extensions", "pandoc_args")}.
##' @importFrom rmarkdown render
##' @importFrom rmarkdown html_document
##' @importFrom utils modifyList
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
##' of1 <- rmd2html(fp, output_dir = getwd())
##' if(interactive()) browseURL(of1[1])
##' of2 <- rmd2html(fp, toc = FALSE, output_dir = getwd())
##' if(interactive()) browseURL(of2[1])
##' setwd(wd.orig)
rmd2html <- function(fn = NULL, wd = NULL, verbose = FALSE, ...) {
    if (!is.null(wd)){
        wd.orig <- getwd()
        setwd(wd)
    }
        
    if (is.null(fn)) {
        cat("Will render all *.Rmd files in current working directory\n")
        fn <- list.files(pattern="Rmd$")
    }    

    dots <- list(...)
    formals_html_document <- c("toc", "toc_depth", "toc_float",
                               "number_sections", "section_divs",
                               "fig_width", "fig_height",
                               "fig_retina", "fig_caption", "dev",
                               "df_print", "code_folding",
                               "code_download", "smart",
                               "self_contained", "theme", "highlight",
                               "mathjax", "template",
                               "extra_dependencies", "css",
                               "includes", "keep_md", "lib_dir",
                               "md_extensions", "pandoc_args")
    dots_for_html_document <- dots[formals_html_document[formals_html_document %in% names(dots)]]
  
    formals_render <- c("output_file", "output_dir", "output_options",
                        "intermediates_dir", "knit_root_dir",
                        "runtime", "clean", "params", "knit_meta",
                        "envir", "run_pandoc", "quiet", "encoding")

   
    dots_for_render <- dots[formals_render[formals_render %in% names(dots)]]
       
    html_args <- list(css = system.file("extdata/theme", "kutils.css", package = "crmda"),
                      toc = TRUE)
    html_argz <- modifyList(html_args, dots_for_html_document)
    if(verbose) {print(paste("dots_for_html")); lapply(html_argz, print)}
    
    htmldoc <- do.call(rmarkdown::html_document, html_argz)
    
    res <- sapply(fn, function(x) {
        render_args <- list(input = x, output_format = htmldoc, quiet = !verbose,
                            envir = globalenv())
        render_argz <- modifyList(render_args, dots_for_render)
        browser()
        knitr::purl(fn)
        if(verbose) {print(paste("dots_for_render"));  lapply(dots_for_render, print)}
        do.call(rmarkdown::render, render_argz)
    })
    if (!is.null(wd)){
        setwd(wd.orig)
    }
    res
}




##' Rmd to PDF
##'
##' It makes sure that the style sheet we want to use is applied to the data.
##'
##' Running this will be the same as running the rmd2pdf.sh script
##' within the directory.
##' @param fn A file name. If not specified, then all Rmd documents
##'     within directory are rendered.
##' @param wd A working directory name of the Rmd file. If not
##'     specified, then the current working directory from R will be
##'     used.
##' @param verbose The opposite of render(quiet = TRUE). Shows compile
##'     commentary and pandoc command. Can be informative!
##' @param ... Arguments that will be passed to \code{render} and
##'     \code{pdf_document}. Our defaults set a LaTeX template, toc =
##'     TRUE, and the pandoc_args includes use of the listings class.
##'     Users may override by specifying named arguments for
##'     \code{render()}: \code{c("output_file", "output_dir",
##'     "output_options", "intermediates_dir", "knit_root_dir",
##'     "runtime", "clean", "params", "knit_meta", "envir",
##'     "run_pandoc", "quiet", "encoding")}. Users may also specify
##'     named arguments for \code{pdf_document:} \code{("toc",
##'     "toc_depth", "number_sections", "fig_width", "fig_height",
##'     "fig_crop", "fig_caption", "dev", "df_print", "highlight",
##'     "template", "keep_tex", "latex_engine", "citation_package",
##'     "includes", "md_extensions", "pandoc_args",
##'     "extra_dependencies")}.
##' @importFrom rmarkdown render
##' @importFrom rmarkdown pdf_document
##' @importFrom utils modifyList
##' @return A vector of output file names
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @export
##' @examples
##' ## put some file name in
##' fp <- system.file("extdata/rmd2pdf-guide", "guide-template.Rmd", package = "crmda")
##' tdir <- tempdir()
##' file.copy(fp, to = tdir, copy.mode = TRUE, copy.date = TRUE)
##' wd.orig <- getwd()
##' setwd(tdir)
##' of1 <- rmd2pdf(fp, output_dir = getwd())
##' ## if(interactive()) browseURL(of1[1])
##' of2 <- rmd2pdf(fp, toc = FALSE, output_dir = getwd())
##' ## if(interactive()) browseURL(of2[1])
##' setwd(wd.orig)
rmd2pdf <- function(fn = NULL, wd = NULL, verbose = FALSE, ...) {
    if (!is.null(wd)){
        wd.orig <- getwd()
        setwd(wd)
    }
        
    if (is.null(fn)) {
        cat("Will render all *.Rmd files in current working directory\n")
        fn <- list.files(pattern="Rmd$")
    }    

    dots <- list(...)

    formals_pdf_document <- c("toc", "toc_depth",
                              "number_sections", "fig_width", "fig_height", "fig_crop",
                              "fig_caption", "dev", "df_print", "highlight", "template",
                              "keep_tex", "latex_engine", "citation_package", "includes",
                              "md_extensions", "pandoc_args", "extra_dependencies")

    dots_for_pdf_document <- dots[formals_pdf_document[formals_pdf_document %in%
    names(dots)]]
  
    formals_render <- c("output_format", "output_file", "output_dir", "output_options",
                        "intermediates_dir", "knit_root_dir",
                        "runtime", "clean", "params", "knit_meta",
                        "envir", "run_pandoc", "quiet", "encoding")

   
    dots_for_render <- dots[formals_render[formals_render %in% names(dots)]]
       
    pdf_args <- list(highlight="haddock",
                     template = system.file("extdata/rmd2pdf-report/theme", "crmda-boilerplate.tex", package = "crmda"),
                     pandoc_args="--listings")
    pdf_argz <- modifyList(pdf_args, dots_for_pdf_document)
    if(verbose) {print(paste("dots_for_pdf")); lapply(pdf_argz, print)}
    
    pdfdoc <- do.call(rmarkdown::pdf_document, pdf_argz)
    
    res <- sapply(fn, function(x) {
        render_args <- list(input = x, output_format = pdfdoc, quiet = !verbose,
                            envir = globalenv())
        render_argz <- modifyList(render_args, dots_for_render)
        knitr::purl(fn)
        if(verbose) {print(paste("dots_for_render"));  lapply(dots_for_render, print)}
        do.call(rmarkdown::render, render_argz)
    })
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
##' @param engine "knitr" or "Sweave"
##' @param verbose if FALSE, the knitr quiet is set as TRUE
##' @param envir environment for evaluation, see \code{knitr}
##'     documents, defaults to parent.frame().
##' @param encoding character encoding, defaults from user options
##' @return NULL
##' @export
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @importFrom knitr knit2pdf
##' @importFrom knitr knit
##' @importFrom utils Sweave
##' @importFrom utils Stangle
##' @examples
##' wd.orig <- getwd()
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
##' setwd(wd.orig)
rnw2pdf <- function(fn = NULL, wd = NULL, engine = "knitr", verbose = FALSE,
                    envir = parent.frame(), encoding = getOption("encoding")) {
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
                knitr::knit(x, quiet = !verbose, tangle = TRUE, envir = envir,
                            encoding = encoding)
                fnpdf <- knitr::knit2pdf(x, quiet = !verbose, envir = envir,
                            encoding = encoding)
            } else {
                Sweave(x)
                Stangle(x)
                tools::texi2pdf(gsub("\\.Rnw$", ".tex", x, ignore.case = TRUE),
                                texi2dvi = "texi2pdf")
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
