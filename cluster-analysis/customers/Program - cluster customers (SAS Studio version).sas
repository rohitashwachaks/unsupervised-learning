* Read in customers data;
PROC IMPORT DATAFILE="/home/tomsager/CA/Customers.xlsx"
		    OUT=customers
		    DBMS=XLSX
		    REPLACE;
RUN;
* Cluster the customers on all of their variables;
proc cluster data=customers  STANDARD  METHOD=WARD  
              OUTTREE=customers_TREE  CCC  PSEUDO;
  var income--Prev_Parent_Mag; * Double hyphen includes all vars in the range, as ordered in the dataset;
RUN;
* Find the 8-cluster solution and add cluster number to dataset;
PROC TREE DATA=customers_TREE NCLUSTERS=8 OUT=customers_NCL_8;
  COPY _NUMERIC_; * Copy all numeric vars from input to output dataset;
RUN;
* Find how clusters differ from each other;
PROC MEANS DATA=customers_NCL_8 n mean std;
  VAR income--Prev_Parent_Mag;
  CLASS cluster;
RUN;

** Alternative clustering: K-means, via PROC FASTCLUS **;
* There is often an initial pre-clustering, followed by a clustering of the pre-clusters;
* Standardize customer data prior to using FASTCLUS, which lacks internal standardization;
* Method STD subtracts mean and divides by standard deviation;
PROC STDIZE  DATA=customers METHOD=STD OUT=std_customers;
  VAR income--Prev_Parent_Mag;
RUN;
** K-means clustering: K=50 (pre-clusters)**;
* Get 50 preliminary seed clusters and store their centroids in MEAN= dataset;
PROC FASTCLUS  DATA=std_customers  MEAN=mean_STD_fast_customers  MAXCLUSTERS=50 MAXITER=40;
  VAR income--Prev_Parent_Mag;
RUN;
* Check quality of the 50 seeds by plotting inter-cluster gap and cluster radius vs number in cluster;
PROC PLOT  DATA=mean_std_fast_customers;
  PLOT _GAP_*_FREQ_='G'  _RADIUS_*_FREQ_='R';
RUN;
* Delete low-count initial clusters (may not be necessary);
DATA mean_std_fast_customers;
  SET mean_std_fast_customers;
  IF _FREQ_ < 5 THEN DELETE;
RUN;
* Cluster the pre-clusters: K-means clustering: K=8;
* Use remaining seed clusters (SEED=) in FASTCLUS to get at most 8 clusters;
* Hopefully, the 8 will be from high frequency pre-clusters;
* Do not permit clusters more than distance=3 apart to join (STRICT=3) - limits outlier influence - may not be necessary; 
* Add cluster assignments to OUT= dataset;
PROC FASTCLUS  DATA=std_customers  SEED=mean_std_fast_customers  STRICT=3.0
               OUTSEED=mean_std_fast_customers2
               OUT=out_mean_std_fast_customers MAXCLUSTERS=8 MAXITER=40;
  VAR income--Prev_Parent_Mag;
RUN;
* Run FASTCLUS once more to assign remaining observations to clusters (MAXITER=0);
* Without this step, some cases may be assigned negative cluster numbers.;
* A negative value indicates that the case was not assigned to a cluster (see the STRICT option),;
* and the number is the cluster to which it would have been assigned.;
PROC FASTCLUS  DATA=std_customers  SEED=mean_std_fast_customers2  
               OUT=out_mean_std_fast_customers MAXCLUSTERS=8 MAXITER=0;
  VAR income--Prev_Parent_Mag;
RUN;
* Find how clusters differ from each other;
* Since FASTCLUS used standardized data, their means will be hard to interpret; 
* Extract K-means cluster number and add to CUSTOMERS dataset;
DATA FS_cluster;
  SET out_mean_std_fast_customers;
  KEEP cluster; * The only variable in the output dataset;
RUN;
* Side-by-side merge without matching control;
DATA customers;
  merge customers FS_cluster;
RUN;
PROC MEANS DATA=customers  n mean std;
  VAR income--Prev_Parent_Mag;
  CLASS cluster;
RUN;



