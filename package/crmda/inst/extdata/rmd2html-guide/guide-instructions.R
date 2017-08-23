## ----setup, include=FALSE------------------------------------------------
##This Invisible Chunk is required in all CRMDA documents
outdir <- paste0("tmpout")
if (!file.exists(outdir)) dir.create(outdir, recursive = TRUE)
knitr::opts_chunk$set(echo=TRUE, comment=NA, fig.path=paste0(outdir, "/p-"))
options(width = 70)

## ----myFirstPlot, dev=c('png','pdf'), fig.keep='all'---------------------
hist(rnorm(500))

## ------------------------------------------------------------------------
x <- rnorm(1000)
print(x[1:20])

## ----mySecondPlot, dev=c('png','pdf'), fig.keep='all'--------------------
hist(rnorm(20))

## ---- warning = FALSE, error = FALSE, message= FALSE,include=FALSE-------
library(rockchalk)
   set.seed(2134234)
   dat <- data.frame(x1 = rnorm(100), x2 = rnorm(100))
   dat$y1 <- 30 + 5 * rnorm(100) + 3 * dat$x1 + 4 * dat$x2
   dat$y2 <- rnorm(100) + 5 * dat$x2
   m1 <- lm(y1 ~ x1, data = dat)
   m2 <- lm(y1 ~ x2, data = dat)
   m3 <- lm(y1 ~ x1 + x2, data = dat)
   gm1 <- glm(y1 ~ x1, family = Gamma, data = dat)

or1 <- outreg(list("Amod" = m1, "Bmod" = m2, "Gmod" = m3),
title = "My Three Linear Regressions", float = FALSE, type = "html",
browse = FALSE)
or1 <- gsub("&nbsp;"," ", or1)
or1 <- gsub("^\\ *", "", or1)
or1 <- paste(or1, collapse = "")
or1 <- gsub("\\ \\ \\ \\ \\ \\ ", " ", or1)
or1 <- gsub("\\ \\ \\ ", " ", or1)

## ----results="asis"------------------------------------------------------
cat(or1)

## ---- results="asis"-----------------------------------------------------
    library(xtable)
    or2 <- xtable(summary(m1))
    print(or2, type="html")

## ---- results="asis"-----------------------------------------------------
    library(psych)
print(xtable(describe(dat)),type = "html")
    

## ---- eval=FALSE, include=FALSE------------------------------------------
## bscols <- data.frame(old = c("info", "warning", "danger"),
##                      new = c("blue", "orange", "red"))

## ----xsummary------------------------------------------------------------
summary(x)

## ----sessionInfo, echo = FALSE-------------------------------------------
sessionInfo()

