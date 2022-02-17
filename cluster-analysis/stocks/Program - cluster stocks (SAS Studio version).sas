PROC IMPORT DATAFILE="/home/tomsager/CA/Stock data.xlsx"
		    OUT=stocks
		    DBMS=XLSX
		    REPLACE;
RUN;
PROC CLUSTER  DATA=STOCKS  STANDARD  METHOD=WARD  
              OUTTREE=STOCKTREE  CCC  PSEUDO;
  var P_E profit growth;
  COPY industry firm;  
  TITLE "19 Stocks Clustered by WARD's Method on 3 Variables"; 
PROC TREE DATA=STOCKTREE OUT=STOCKOUT NCLUSTERS=3;
  COPY  P_E GROWTH;
RUN;  
PROC PLOT DATA=STOCKOUT;
  PLOT P_E * GROWTH = CLUSTER;
RUN;
