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
  COPY  P_E GROWTH profit firm industry;
RUN;  
PROC PLOT DATA=STOCKOUT;
  PLOT P_E * GROWTH = CLUSTER;
RUN;

* Test R-squares for regressions with cluster memberships;
* Create cluster membership indicators CL1, Cl2, Cl3;
data stockout;
  set stockout;
  if cluster=1 then CL1=1; else CL1=0;
  if cluster=2 then CL2=1; else CL2=0;
  if cluster=3 then CL3=1; else CL3=0;
run; 
* Explanatory power of CL1 for each clustering variable;
proc reg data=stockout;
  model p_e    = CL1;
  model profit = CL1;
  model growth = CL1;
RUN;
* Explanatory power of the entire clustering for each clustering variable;
* Cannot use all CL1, CL2, CL3 b/c multicollinear;
proc reg data=stockout;
  model p_e    = CL1 CL2;
  model profit = CL1 CL2;
  model growth = CL1 CL2;
RUN;
  model growth = CL1 CL2;
RUN;
proc univariate data=stockout;
  var profit;
RUN;

  
  
  