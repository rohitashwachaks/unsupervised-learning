* Read Austin apartment data into SAS;
libname PCA "/home/tomsager/PCA";
data PCA.apts;
  input Rent  Area  Bedrooms  Bathrooms  Security  Parking  Distance  Shuttle  Age;
cards;
519  725  1  1  0  0  10.5  1  9
765  995  2  2  0  0  6.5  1  17
475  481  1  1  0  0  6.5  1  17
575  925  2  2  0  1  4  1  9
415  600  1  1  0  0  5  1  30
530  668  1  1  0  0  6.5  1  19
580  725  1  1  0  0  7  1  17
995  1421  2  2  0  1  6.5  1  16
565  672  1  1  0  0  7  1  17
620  1025  2  1  1  0  5  1  3
450  781  1  1  1  0  5.5  1  3
520  800  2  1  0  0  6  1  20
495  870  2  1  0  0  5  1  27
420  700  1  1  0  0  6  1  22
575  800  1  1  0  0  7  1  10
425  620  1  1  0  0  8  0  27
770  1040  2  2  0  1  6.5  1  16
445  520  1  1  0  0  3  1  12
510  880  2  1  0  1  7  0  25
635  832  1  1  0  0  6  1  13
470  545  1  1  0  0  6.5  1  9
700  921  2  2  0  0  3  1  26
450  577  1  1  0  0  8  1  18
785  1080  2  2  0  0  5  1  10
485  710  1  1  0  0  6  1  25
415  605  1  1  0  0  6  1  22
399  680  1  1  0  1  7  0  25
585  730  2  1  0  0  6.5  1  19
525  687  1  1  0  0  7  1  15
495  703  1  1  0  0  6.5  1  14
505  672  1  1  1  0  6.5  1  9
445  660  1  1  0  0  6  1  25
565  755  2  1  0  0  3  1  12
650  810  2  1  0  0  2  1  32
515  611  1  1  0  0  6.5  1  17
470  705  1  1  0  0  7.5  0  13
470  564  1  1  0  0  5  1  10
700  1250  3  2  0  1  4  1  9
455  512  1  1  1  0  10  0  10
550  630  1  1  0  0  2  1  32
625  850  2  1  1  0  7  1  1
745  1156  3  2  0  0  7.5  0  13
540  932  2  1  0  0  6  1  22
650  755  1  1  1  1  1.1  1  26
595  1093  2  2  1  0  5.5  1  3
470  751  1  1  1  0  5  1  3
480  608  1  1  0  0  6  1  15
460  900  1  1  0  1  4  1  9
600  860  2  1  0  0  6  1  25
575  925  2  1  0  0  6  1  23
659  944  2  2  0  0  7  1  25
650  940  2  2  0  0  8  0  27
750  1048  2  2  0  0  7  1  3
455  474  1  1  0  0  5  1  10
430  700  1  1  0  0  6  1  20
605  921  1  1  0  0  7.5  0  13
929  1229  2  2  1  0  5  1  11
695  896  2  2  0  0  6.5  1  19
455  630  1  1  1  0  5.5  1  9
1050  1864  5  2  0  0  6  1  22
RUN;

* Extract principal components;
proc princomp data=PCA.apts out=apts_PC;
  var  Area  Bedrooms  Bathrooms  Security  Parking  Distance  Shuttle  Age;
RUN;

* Compare regression on variables with regression on PCs;
* SS1 option computes contribution to explanatory power that an X adds to that of all Xs listed before it in MODEL;
* SS2 option computes contribution to explanatory power that an X adds to that of all other Xs;
* VIF = Variance Inflation Factor = proportion the variance of a coefficient is inflated b/c Xs are not independent;
proc reg data=apts_PC;
  model rent = Area  Bedrooms  Bathrooms  Security  Parking  Distance  Shuttle  Age  / ss1 ss2 vif;
  model rent = PRIN1-PRIN8 / ss1 ss2 vif;
  model rent = PRIN1-PRIN3 / ss1 ss2 vif;
  model rent = PRIN1 PRIN4 PRIN8 / ss1 ss2 vif;
RUN;
