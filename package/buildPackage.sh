PACKAGE="crmda"

VERSION=$(awk -F": +" '/^Version/ { print $2 }' ${PACKAGE}/DESCRIPTION)

rm -rf ${PACKAGE}.gitex;

mkdir ${PACKAGE}.gitex

cd ${PACKAGE}

cd vignettes
R -e "library(crmda); rmd2pdf(\"crmda.Rmd\", toc=TRUE, type = \"guide\")"
R -e "library(crmda); rmd2pdf(\"Rmarkdown.Rmd\", toc=TRUE, type = \"report\")"
R -e "library(crmda); rmd2pdf(\"code_chunks.Rmd\", toc=TRUE, type = \"report\")"
R -e "library(crmda); rmd2html(\"HTML_special_features.Rmd\", toc=TRUE)"
cd ..

## copies UNCOMMITTED but TRACKED files.
git ls-files . | tar cT - | tar -x -C "../${PACKAGE}.gitex"
cd ..

cd ${PACKAGE}.gitex
cp -f ../crmda/vignettes/crmda.pdf inst/doc
cp -f ../crmda/vignettes/Rmarkdown.pdf inst/doc
cp -f ../crmda/vignettes/code_chunks.pdf inst/doc
cp -f ../crmda/vignettes/HTML_special_features.html inst/doc
cd ..

R --vanilla -f runRoxygen2.R


R CMD build ${PACKAGE}.gitex --resave-data --no-build-vignettes


read -p "Run check: OK? (y or n)" result

if [ $result = "y" ];  then
R CMD check --as-cran ${PACKAGE}_${VERSION}.tar.gz
fi

read -p "Install: OK? (y or n)" result
if [ $result = "y" ]; then
R CMD INSTALL ${PACKAGE}_${VERSION}.tar.gz
fi


read -p "Erase git temporary: OK? (y or n)" result
if [ $result = "y" ]; then
rm -rf ${PACKAGE}.gitex
fi


read -p "Erase Rcheck temporary: OK? (y or n)" result
if [ $result = "y" ]; then
rm -rf ${PACKAGE}.Rcheck
fi


echo "Consider upload to KRAN"
