PACKAGE="crmda"

VERSION=$(awk -F": +" '/^Version/ { print $2 }' ${PACKAGE}/DESCRIPTION)

rm -rf ${PACKAGE}.gitex;

mkdir ${PACKAGE}.gitex
cd ${PACKAGE}

## cd vignettes
##lyx -f -e sweave variablekey.lyx;
## cd ..

## copies UNCOMMITTED but TRACKED files.
git ls-files . | tar cT - | tar -x -C "../${PACKAGE}.gitex"
cd ..

cd ${PACKAGE}.gitex/vignettes
cp -f crmda/crmda.pdf ../inst/doc
cp -f Rmarkdown/Rmarkdown.pdf ../inst/doc
cp -f code_chunks/code_chunks.pdf ../inst/doc
cd ../..

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
