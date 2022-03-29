* Read in data on customers;
PROC IMPORT DATAFILE="D:\(((Business Analytics 2021\Factor analysis\Customers.xlsx"
		    OUT=customers
		    DBMS=XLSX
		    REPLACE;
RUN;

* Tentatively decide on number of factors to retain;
PROC FACTOR   DATA=customers SCREE PRIORS=one ROTATE=varimax;
  VAR income--Prev_Parent_Mag;
  TITLE 'Principal Components Analysis followed by VARIMAX -- Customer Data';
RUN;

* SMC and QUARTIMAX approach;
PROC FACTOR   DATA=customers SCREE PRIORS=smc ROTATE=quartimax;
  VAR income--Prev_Parent_Mag;
  TITLE 'Principal Components Analysis (the default) -- Customer Data';
RUN;

* An oblique rotation (PROMAX);
PROC FACTOR   DATA=customers SCREE PRIORS=one ROTATE=promax;
  VAR income--Prev_Parent_Mag;
  TITLE 'PROMAX non-orthonormal oblique rotation -- Customer Data';
RUN;

* Maximum Likelihood estimation;
* First, standardize the data;
proc stdize data=customers out=st_customers;
  VAR income--Prev_Parent_Mag;
RUN;
PROC FACTOR   DATA=st_customers SCREE METHOD=ML HEYWOOD ROTATE=varimax;
  VAR income--Prev_Parent_Mag;
  TITLE 'Maximum Likelihood Estimation (assumes normal distribution) -- Customer Data';
RUN;
