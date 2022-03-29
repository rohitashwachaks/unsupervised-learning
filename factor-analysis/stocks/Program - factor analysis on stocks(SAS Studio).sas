* Read raw data into SAS ds STOCKS;
PROC IMPORT DATAFILE="/home/tomsager/FA/Stock data.xlsx"
		    OUT=stocks
		    DBMS=XLSX
		    REPLACE;
RUN;

* Run PCA to compare with FA;
PROC PRINCOMP DATA=STOCKS;
  VAR P_E profit growth;
  TITLE "PCA on 19 Stocks and 3 Variables"; 
RUN;
* Principal components analysis as a "special case" of factor analysis;
* The FA default options are METHOD=principal PRIORS=one MINEIGEN=1;
* METHOD=principal extracts uncorrelated (orthogonal) factors;
* PRIORS=one sets uniqueness=0 and communality=1 for each manifest variable;
* MINEIGEN=0 extracts all factors with eigenvalue > 0 (i.e., all factors);
PROC FACTOR DATA=stocks METHOD=principal PRIORS=one MINEIGEN=0;
  VAR P_E profit growth;
  TITLE "Factor Analysis on 19 Stocks and 3 Variables"; 
RUN;

* Three follow-up orthonormal rotations that attempt to improve interpretability of factors;
* ROTATE=varimax simplifies by maximizing variance of columns of factor pattern;
PROC FACTOR DATA=stocks METHOD=principal PRIORS=one MINEIGEN=0 ROTATE=varimax;
  VAR P_E profit growth;
  TITLE "Factor Analysis on 19 Stocks and 3 Variables, followed by VARIMAX rotation"; 
RUN;
* ROTATE=quartimax simplifies by maximizing variance of rows of factor pattern;
PROC FACTOR DATA=stocks METHOD=principal PRIORS=one MINEIGEN=0 ROTATE=quartimax;
  VAR P_E profit growth;
  TITLE "Factor Analysis on 19 Stocks and 3 Variables, followed by QUARTIMAX rotation"; 
RUN;
* ROTATE=equamax simplifies by maximizing variance of combination of columns and rows of factor pattern;
PROC FACTOR DATA=stocks METHOD=principal PRIORS=one MINEIGEN=0 ROTATE=equamax;
  VAR P_E profit growth;
  TITLE "Factor Analysis on 19 Stocks and 3 Variables, followed by EQUAMAX rotation"; 
RUN;

* Non-PCA factor analysis;
* PRIORS=smc uses squared multiple correlations as initial estimates of communalities
   (and thus 1 - smc as initial estimates of uniqueness of each manifest variable);
* NFACTORS=2 asks for 2 factors to be extracted (not obeyed if some factors meaningless);
PROC FACTOR DATA=stocks METHOD=principal PRIORS=SMC NFACTORS=2;
  VAR P_E profit growth;
  TITLE "A 'regular' factor analysis on 19 Stocks and 3 Variables";
RUN;

* Calculate (estimated) factor scores (OUT=<SAS ds>) and
   and create SAS dataset to score other data (OUTSTAT=<SAS ds>);
PROC FACTOR DATA=stocks METHOD=principal PRIORS=SMC NFACTORS=2 OUTSTAT=stocks_stats OUT=stocks_out;
  VAR P_E profit growth;
  TITLE "Calculate factor scores for STOCKS data";
RUN;
* Score the (original) manifest variables in STOCKS
   using scoring information in STOCKS_STATS
   and put scores in STOCKS_WITH_SCORES;
PROC SCORE DATA=STOCKS  SCORE=stocks_stats  OUT=stocks_with_scores;
  VAR P_E profit growth;
  TITLE "Score the data in STOCKS";
RUN;
