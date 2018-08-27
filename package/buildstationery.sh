PACKAGE="stationery"

VERSION=$(awk -F": +" '/^Version/ { print $2 }' ${PACKAGE}/DESCRIPTION)

rm -rf ${PACKAGE}.gitex;

mkdir ${PACKAGE}.gitex

cd ${PACKAGE}

## cd vignettes
## ./compiler.sh
## cd ..

## copies UNCOMMITTED but TRACKED files.
git ls-files . | tar cT - | tar -x -C "../${PACKAGE}.gitex"
cd ..

## cd ${PACKAGE}.gitex
## mkdir -p inst/doc
## mv -f ../stationery/vignettes/*.pdf* inst/doc
## mv -f ../stationery/vignettes/*.html* inst/doc
## touch inst/doc/index.html
## cd ..
R --vanilla -f roxygenstationery.R


## R CMD build --resave-data --no-build-vignettes ${PACKAGE}.gitex 
## R CMD build --no-resave-data --compact-vignettes="both" ${PACKAGE}.gitex 

## /usr/lib/R/bin/R --no-site-file --no-environ --no-save --no-restore --quiet  \
##                 CMD build 'stationery.gitex'  --no-resave-data --no-manual --run-donttest \
##                 --compact-vignettes="both" --no-build-vignettes

/usr/lib/R/bin/R --no-site-file --no-environ --no-save --no-restore --quiet  \
                 CMD build 'stationery.gitex'  --no-resave-data --no-manual \
                 --compact-vignettes="both"

read -p "Run check: OK? (y or n)" result

if [ $result = "y" ];  then
R CMD check --as-cran --run-donttest ${PACKAGE}_${VERSION}.tar.gz
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
