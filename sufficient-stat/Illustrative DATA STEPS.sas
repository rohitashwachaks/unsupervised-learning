
/****************************************/
/* CREATING and NAMING SAS DATA SETS    */
/****************************************/

* Creates WORK.DATA1;
* Gets data from the program;
data;
  input name $ salary age tenure gender $;
cards;
Bill 27000 32 7 M
Sally 30000 40 10 F
RUN;

* Creates WORK.RECORDS;
* Gets data from the program;
data records;
  input name $ salary age tenure gender $;
cards;
Bill 27000 32 7 M
Sally 30000 40 10 F
RUN;

* Creates BA.RECORDS;
* Gets data from the program;
libname TOM '/home/tomsager/BA/';
data tom.records;
  input name $ salary age tenure gender $;
cards;
Bill 27000 32 7 M
Sally 30000 40 10 F
RUN;

* Creates WORK.GALTON;
* Gets data from text file;
data Galton;
  infile '/home/tomsager/BA/Father-son heights.txt' firstobs=2;
  input father son;
cards;
run;

* Creates WORK.CEREALS;
* Gets data from extant SAS data set;
data cereals;
  set BA.cereals;
run;