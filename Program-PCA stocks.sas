* Read in data on 19 stocks;
libname PCA "/home/tomsager/PCA";
PROC IMPORT DATAFILE="/home/tomsager/PCA/Stock data.xlsx"
		    OUT=WORK.stocks
		    DBMS=XLSX
		    REPLACE;
RUN;

* Extract principal components of stocks data;
proc princomp data=stocks;
  var P_E   PROFIT   GROWTH;
RUN; 
