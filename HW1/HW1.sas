* Read Jobs data into SAS;
libname HW1 "/home/u60742788/HW1";

data HW1.jobs;
  input job knowhow problem_solving accountability salary;
cards;
0  800  608  1056  102000
2  528  304  460  75740
3  460  264  460  75740
5  528  304  304  79172
4  460  264  400  70000
0  460  264  400  66536
0  528  304  264  70000
7  460  230  264  68000
10  400  200  350  73140
7  400  175  230  66016
7  400  200  200  66016
5  400  175  200  71840
5  304  115  175  71580
2  264  100  175  65860
3  264  100  175  66432
10  230  100  132  64040
10  230  100  132  62610
7  230  87  132  65002
7  230  76  115  64001
5  230  76  115  66900
5  230  87  100  63000
5  230  87  100  63780
7  200  87  100  62000
7  200  76  100  61960
7  200  76  100  62012
7  200  76  87  62300
5  200  76  87  61960
7  200  66  87  61700
7  175  66  100  61440
2  175  57  100  62220
3  175  57  100  63260
7  175  57  100  59880
2  175  57  100  62480
3  175  57  100  63000
2  175  57  100  63260
3  175  57  100  62480
4  175  57  87  62480
7  175  57  87  61440
2  175  57  87  62064
3  175  57  87  61180
2  175  57  87  59100
3  175  57  87  59620
5  175  66  76  59880
5  175  66  76  60200
7  175  57  76  60140
7  175  57  76  61700
5  175  66  66  60000
7  152  50  87  60920
7  152  50  76  59100
3  152  50  76  61700
2  152  50  76  59880
3  152  50  76  61700
5  152  50  66  59360
5  152  43  66  60660
2  152  43  66  59984
2  152  43  66  60660
3  152  43  66  60920
3  152  43  66  60920
2  152  43  66  60920
3  152  43  66  60660
3  152  43  66  60660
7  152  43  66  58320
5  152  43  66  59360
2  152  43  66  60920
3  152  43  66  60920
4  152  43  66  60660
7  152  43  57  59880
RUN;

* Standardise the data;
PROC STANDARD
    DATA = HW1.jobs
    MEAN=0 
    STD=1
    OUT = HW1.jobs_std;
    
    VAR knowhow problem_solving accountability;
RUN;

* Q1 - Extract principal components;
PROC PRINCOMP DATA=HW1.jobs_std OUT=HW1.jobs_pc;
  VAR  knowhow problem_solving accountability;
RUN;

* Q5 - Regress Prin1 on the 3 ratings;
PROC REG DATA = HW1.jobs_pc;
MODEL Prin1 = knowhow problem_solving accountability / NOINT; * NoINT = No intercept term;
RUN;

* Q6 - Regress knowhow on the 3 principal components;
PROC REG DATA = HW1.jobs_pc;
MODEL knowhow = Prin1 Prin2 Prin3 / NOINT; * NoINT = No intercept term;
RUN;

* Q7 - Obtain Loadings Matrix for Principal Components v/s the 3 selected attributes; 
PROC CORR data=HW1.jobs_pc;
  var Prin1 Prin2 Prin3;
  with knowhow problem_solving accountability;
RUN;

* Q9 - Regress salary on the 3 principal components;
PROC REG DATA = HW1.jobs_pc;
MODEL salary = Prin1 Prin2 Prin3;
RUN;

* Q10 (c) - Regress salary on the Prin1 alone;
PROC REG DATA = HW1.jobs_pc;
MODEL salary = Prin1;
RUN;

