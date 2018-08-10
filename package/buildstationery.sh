PACKAGE="stationery"

VERSION=$(awk -F": +" '/^Version/ { print $2 }' ${PACKAGE}/DESCRIPTION)

rm -rf ${PACKAGE}.gitex;

mkdir ${PACKAGE}.gitex

cd ${PACKAGE}

cd vignettes
./compiler.sh
cd ..

## copies UNCOMMITTED but TRACKED files.
git ls-files . | tar cT - | tar -x -C "../${PACKAGE}.gitex"
cd ..

cd ${PACKAGE}.gitex
mkdir -p inst/doc
cp -f ../stationery/vignettes/*.pdf* inst/doc
cp -f ../stationery/vignettes/*.html* inst/doc

cd ..
R --vanilla -f roxygenstationery.R


## R CMD build --resave-data --no-build-vignettes ${PACKAGE}.gitex 
R CMD build --resave-data ${PACKAGE}.gitex 



read -p "Run check: OK? (y or n)" result

if [ $result = "y" ];  then
R CMD check --as-cran --no-build-vignettes ${PACKAGE}_${VERSION}.tar.gz
##R CMD check --as-cran ${PACKAGE}_${VERSION}.tar.gz
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
