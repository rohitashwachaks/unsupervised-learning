* Read in cereals data;
libname PCA "/home/tomsager/PCA";
PROC IMPORT DATAFILE="/home/tomsager/PCA/Cereals.xlsx"
		    OUT=WORK.cereals
		    DBMS=XLSX
		    REPLACE;
RUN;

* Extract principal components of cereals data;
proc princomp data=cereals;
  var calories protein fat sodium fiber carbo sugars 
      potass vitamins weight cups;
RUN; 
