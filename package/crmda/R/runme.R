
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
##' @param purl Default TRUE, synonym for tangle. Set either one, or
##'     set both same, result is same.
##' @param tangle Default TRUE, synonym for purl
##' @param verbose The opposite of render(quiet = TRUE). Shows compile
##'     commentary and pandoc command. Can be informative!
##' @param template An html template file, defaults as
##'     guide-boilerplate.html in this packge.
##' @param css Cascading style sheet, defaults as kutils.css in this
##'     package
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
##' fp <- system.file("rmarkdown/templates/rmd2html-guide/skeleton", "skeleton.Rmd", package = "crmda")
##' tdir <- tempdir()
##' file.copy(fp, to = tdir, copy.mode = TRUE, copy.date = TRUE)
##' wd.orig <- getwd()
##' setwd(tdir)
##' of1 <- rmd2html(fp, output_dir = getwd())
##' if(interactive()) browseURL(of1[1])
##' of2 <- rmd2html(fp, toc = FALSE, output_dir = getwd())
##' if(interactive()) browseURL(of2[1])
##' setwd(wd.orig)
rmd2html <- function(fn = NULL, wd = NULL, verbose = FALSE, purl = TRUE, tangle = purl, 
                     template = system.file("theme", "guide-boilerplate.html", package = "crmda"),
                     css = system.file("theme", "kutils.css", package = "crmda"), ...) {
    if (!missing(tangle) && is.logical(tangle)) purl <- tangle
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
    ## Suppose this is an rmd2html-guide document
    ## crmda_template <- system.file("rmarkdown/templates/rmd2html-guide/skeleton/theme", "guide-boilerplate.html", package = "crmda")
    ## crmda_css <- system.file("rmarkdown/templates/rmd2html-guide/skeleton/theme", "kutils.css", package = "crmda")
    html_args <- list(template = template, 
                      css = css,
                      toc = TRUE)
    
    html_argz <- modifyList(html_args, dots_for_html_document)
    if(verbose) {print(paste("dots_for_html")); lapply(html_argz, print)}
    
    htmldoc <- do.call(crmda::crmda_html_document, html_argz)
    
    res <- sapply(fn, function(x) {
        render_args <- list(input = x, output_format = htmldoc, quiet = !verbose,
                            envir = globalenv())
        render_argz <- modifyList(render_args, dots_for_render)
        if(purl) knitr::purl(fn)
        if(verbose) {print(paste("dots_for_render"));  lapply(dots_for_render, print)}
        do.call(rmarkdown::render, render_argz)
    })
    if (!is.null(wd)){
        setwd(wd.orig)
    }
    res
}




##' custom output_format object to make MathJax work with custom HTML template
##'
##' The \code{rmarkdown::html_document} fails to use MathJax if a custom HTML
##' template is supplied. This is described here
##' \url{https://github.com/rstudio/rmarkdown/issues/727}.  The workaround
##' is to provide this wrapper
##' @param template Name of file that has custom template
##' @param ... Any arguments passed along to html_document in
##'     rmarkdown
##' @return html_document object with custom template
##' @export
##' @author Paul Johnson
crmda_html_document <- function(template = "custom_template", ...) {
  base_format <- rmarkdown::html_document(...)

  template_arg <- which(base_format$pandoc$args == "--template") + 1L
  base_format$pandoc$args[template_arg] <- template

  base_format
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
##' @param type either (default) "report" or "guide"
##' @param purl Default TRUE
##' @param tangle Default TRUE, synonym for purl
##' @param template An LaTeX template file, defaults for type = "report" as
##'     report-boilerplate.tex, or, if type = "guide" then
##'     guide-boilerplate.tex in this package.
##' @param package Defaults as "crmda" to find files in this package.
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
##' wd.orig <- getwd()
##' dir.tmp <- tempdir()
##' setwd(dir.tmp)
##' fmt <- "rmd2pdf-guide"
##' dir.new <- initWriteup(fmt)
##' setwd(dir.new)
##' of1 <- rmd2pdf("skeleton.Rmd", type = "guide", output_dir = getwd())
##' if(interactive()) browseURL(of1[1])
##' of2 <- rmd2pdf("skeleton.Rmd", type = "guide", toc = FALSE, output_dir = getwd())
##' if(interactive()) browseURL(of2[1])
##' setwd(wd.orig)
rmd2pdf <- function(fn = NULL, wd = NULL, verbose = FALSE, type = "report",
                    purl = TRUE, tangle = purl,
                    template = system.file("theme", paste0(type, "-boilerplate.tex"),
                                           package = "crmda"),
                    package = "crmda",
                    ...) {
    if(!missing(tangle) && is.logical(tangle)) purl <- tangle
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
       
    pdf_args <- list(highlight = "haddock",
                     template = template,
                     pandoc_args = "--listings")
    pdf_argz <- modifyList(pdf_args, dots_for_pdf_document)
    if(verbose) {print(paste("dots_for_pdf")); lapply(pdf_argz, print)}
    
    pdfdoc <- do.call(rmarkdown::pdf_document, pdf_argz)
    
    res <- sapply(fn, function(x) {
        render_args <- list(input = x, output_format = pdfdoc, quiet = !verbose,
                            envir = globalenv())
        render_argz <- modifyList(render_args, dots_for_render)
        if (purl) knitr::purl(fn)
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
##' @param purl Default TRUE. Synonym of tangle: extract R code chunks
##' @param tangle Same as purl, both parameters have same result
##' @param clean Default TRUE. Remove intermediate LaTeX files when
##'     using texi2pdf
##' @param verbose Default = FALSE. Functions try to reduce amount of
##'     screen output. Knitr functions that use "quiet" flag will be
##'     set to \code{!verbose}.
##' @param envir environment for evaluation, see \code{knitr}
##'     documents, defaults to parent.frame().
##' @param encoding character encoding, defaults from user options
##' @param ... Other parameters
##' @return NULL
##' @export
##' @author Paul Johnson <pauljohn@@ku.edu>
##' @importFrom knitr knit2pdf
##' @importFrom knitr knit
##' @importFrom utils Sweave
##' @importFrom utils Stangle
##' @examples
##' wd.orig <- getwd()
##' dir.tmp <- tempdir()
##' setwd(dir.tmp)
##' fmt <- "rnw2pdf-guide-sweave"
##' dir.new <- initWriteup(fmt)
##' setwd(dir.new)
##' of1 <- rnw2pdf("skeleton.Rnw", engine = "Sweave")
##' list.files()
##' setwd(wd.orig)
rnw2pdf <- function(fn = NULL, wd = NULL, engine = "knitr", purl = TRUE,
                    tangle = purl, clean = TRUE, verbose = FALSE, envir = parent.frame(),
                    encoding = getOption("encoding"),
                    ...) {
    if(!missing(tangle) && is.logical(tangle)) purl <- tangle
    if (!is.null(wd)) {
        wd.orig <- getwd()
        setwd(wd)
    }
    
    if (is.null(fn)) {
        cat("Will render all *.Rnw files in current working directory\n")
        fn <- list.files(pattern="Rnw")
    }    

    isWindoze <- if(Sys.info()[['sysname']] == "Windows") TRUE else FALSE
    sysnull <-  if(isWindoze) "> nul" else " > /dev/null"
    
    compileme <- function(x, verbose) {
        if (length(grep("\\.lyx$", tolower(x)))){
            ## Let lyx compile to pdf
            cmd <- paste("lyx -e pdf2 ", x, if(!verbose) sysnull)
            if (isWindoze) shell(cmd) else system(cmd)
            fnpdf <- gsub("\\.lyx$", ".pdf", x, ignore.case = TRUE)
            if(tangle){
                ## Remove previous R file, avoid confusion
                unlink(gsub("\\..*$", ".R", x))
                ## lyx can directly export r code from knitr engine file 
                if (tolower(engine) == "knitr"){
                    cmd <- paste("lyx -e r ", x, if(!verbose) sysnull)
                    if (isWindoze) shell(cmd) else system(cmd)
                } else {
                    ## will fail if split=TRUE, so must make copy of file, change to split=FALSE
                    ## Need to turn split to FALSE in order to Tangle the lyx file.
                    bak <- "-uniquebackupstring"
                    fnbackup <- gsub("(.*)(\\..*$)", paste0("\\1", bak, "\\2"), x)
                    file.copy(x, fnbackup, overwrite = TRUE)
                    rnwfile <- readLines(fnbackup)
                    ## Find SweaveOpts line, change split to FALSE
                    rnwfile[grep("SweaveOpts", rnwfile)] <- gsub("(split\\s*=)\\s*.*,", "\\1FALSE,",
                                                                 rnwfile[grep("SweaveOpts", rnwfile)])
                    writeLines(rnwfile, con = fnbackup)
                    cmd <- paste("lyx -e r", fnbackup, if(!verbose) sysnull)
                    if (isWindoze) shell(cmd) else system(cmd)
                    gg <- file.copy(gsub("\\..*$", ".R", fnbackup),
                                    gsub(bak, "", gsub("\\..*$", ".R", fnbackup)),
                                    overwrite=TRUE)
                    if (file.exists(gsub("\\..*$", ".R", x))){
                        unlink(paste0("*", bak, "*"))
                    }
                }
            }
            if(verbose){
                if (tolower(engine) == "knitr"){
                    cmd <- paste("lyx -e knit ", x, if(!verbose) sysnull)
                    if (isWindoze) shell(cmd) else system(cmd)
                } else {
                    cmd <- paste("lyx -e sweave ", x, if(!verbose) sysnull)
                    if (isWindoze) shell(cmd) else system(cmd)
                }
            }
        } else if (length(grep("\\.rnw$", tolower(x)))) {
            if (tolower(engine) == "knitr"){
                if(tangle) knitr::knit(x, quiet = !verbose, tangle = tangle, envir = envir,
                            encoding = encoding)
                fnpdf <- knitr::knit2pdf(x, quiet = !verbose, envir = envir,
                            encoding = encoding)
            } else {
                Sweave(x)
                if (tangle) {
                    bak <- "-tanglebackupstring"
                    fnbackup <- gsub("(.*)(\\..*$)", paste0("\\1", bak, "\\2"), x)
                    file.copy(x, fnbackup, overwrite = TRUE)
                    rnwfile <- readLines(fnbackup)
                    rnwfile[grep("SweaveOpts", rnwfile)] <- gsub("(split\\s*=)\\s*.*,", "\\1FALSE,",
                                                                 rnwfile[grep("SweaveOpts", rnwfile)])
                    writeLines(rnwfile, con = fnbackup)
                    Stangle(fnbackup)
                    fnR <- gsub("\\.Rnw", ".R", fnbackup)
                    if(file.exists(fnR)){
                        fnRrename <- file.copy(fnR, gsub(bak, "", fnR))
                        unlink(paste0("*", bak, "*"))
                    } else {
                        warning("rnw2pdf: failed creation of R tangle file")
                    }
                    if(file.exists(fnbackup)) unlink(fnbackup)
                }
                tools::texi2pdf(gsub("\\.Rnw$", ".tex", x, ignore.case = TRUE),
                                texi2dvi = "texi2pdf", clean = clean, quiet = !verbose)
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
    css <- system.file("theme/kutils.css", package = "crmda") 
    rmarkdown::html_document(toc = toc, css = css, quiet = !verbose)
}
