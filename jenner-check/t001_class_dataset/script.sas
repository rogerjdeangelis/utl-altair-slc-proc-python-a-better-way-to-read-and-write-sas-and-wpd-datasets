/* Derived from utl-altair-slc-proc-python-...sas (rogerjdeangelis).            */
/* The write-up builds a WORKX.CLASS dataset, round-trips it through Python via */
/* pyreadstat, and prints the result as WORKX.STUDENTS. The DATA step that      */
/* defines the dataset and the PROC PRINT that displays it are portable SAS;    */
/* the libname is redirected from d:/wpswrkx to WORK so it runs anywhere.       */

options validvarname=upcase;

data work.class;
 informat
   NAME $8.
   SEX $1.
   AGE 8.
   HEIGHT 8.
   WEIGHT 8.
   ;
 input NAME SEX AGE HEIGHT WEIGHT;
cards4;
Alfred M 14 69 112.5
Alice F 13 56.5 84
Barbara F 13 65.3 98
Carol F 14 62.8 102.5
Ronald M 15 67 133
Thomas M 11 57.5 85
William M 15 66.5 112
;;;;
run;quit;

proc print data=work.class;
run;quit;
