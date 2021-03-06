libname BA   "/home/tomsager/BA";
run;

* Correct 3 variables for skew;
data insurers;
  set BA.life_insurers_2011;
  log_assets      = log(total_assets);
  log_liabilities = log(total_liabilities);
  log_premiums    = log(total_premiums);
RUN;
* Cluster the insurers on 9 variables, including skew-adjusted size measures;
proc cluster data=insurers  STANDARD  METHOD=WARD  
              OUTTREE=Insurance_TREE  CCC  PSEUDO;
  var return_on_capital--log_premiums;
RUN;
* Find the 5-cluster solution and add cluster number to dataset;
PROC TREE DATA=Insurance_TREE NCLUSTERS=5 OUT=insurers_NCL_5;
  COPY _NUMERIC_;
RUN;
* Find how clusters differ from each other;
PROC MEANS DATA=insurers_NCL_5 n mean std;
  VAR return_on_capital--log_premiums;
  CLASS cluster;
RUN;

* Standardize insurer data prior to using FASTCLUS, which lacks internal standardization;
PROC STDIZE  DATA=insurers METHOD=STD OUT=std_insurers;
  VAR total_assets--log_premiums;
RUN;
* Variables in STD_INSURERS are replaced by their standardized versions;
* Get 50 preliminary seed cluster and store their centroids in MEAN= dataset;
PROC FASTCLUS  DATA=std_insurers  MEAN=mean_fast_std_insurers  MAXCLUSTERS=50 MAXITER=40;
  VAR return_on_capital--log_premiums;
RUN;
* Check quality of the 50 seeds by plotting inter-cluster gap and cluster radius vs number in cluster;
PROC PLOT  DATA=mean_fast_std_insurers;
  PLOT _GAP_*_FREQ_='G'  _RADIUS_*_FREQ_='R' / OVERLAY;
RUN;

* Delete poor initial clusters;
DATA mean_fast_std_insurers;
  SET mean_fast_std_insurers;
  IF _FREQ_ < 5 THEN DELETE;
RUN;
* Use remaining seed clusters in FASTCLUS to get at most 5 clusters;
* Do not permit clusters more than distance=3 apart to join; 
* Add cluster assignments to OUT= dataset;
PROC FASTCLUS  DATA=std_insurers  SEED=mean_fast_std_insurers STRICT=3.0 
               OUT=out_mean_fast_std_insurers MAXCLUSTERS=5 MAXITER=40;
  VAR return_on_capital--log_premiums;
RUN;
* Find how clusters differ from each other in original scale;
* For this, transfer K-means cluster numbers to original data;
DATA insurers_fast;
  MERGE insurers out_mean_fast_std_insurers(KEEP=code cluster);
  BY code;
RUN;
PROC MEANS DATA=insurers_fast n mean std;
  VAR return_on_capital--log_premiums;
  CLASS cluster;
RUN;
