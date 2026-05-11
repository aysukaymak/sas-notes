/* From 9-exploring-data.sas — exploring sashelp datasets with PROC PRINT, MEANS, UNIVARIATE, FREQ */

*by default, proc print lists all columns and rows in the input table;
proc print data=sashelp.class;
run;

*use to specify the last observation(row) to read;
proc print data=sashelp.class (obs=10);
run;

*list the first 10 rows from the sashelp.cars table and displays only the Make, Model, Type, and MSRP columns;
proc print data=sashelp.cars (obs=10);
	var make model type msrp;
run;

*by default, PROC MEANS generates simple summary statistics for each numeric column in the input data;
proc means data=sashelp.cars;
	var enginesize horsepower mpg_city mpg_highway;
run;

*by default, PROC UNIVARIATE generates summary statistics for each numeric column in the input data;
proc univariate data=sashelp.cars;
	var mpg_highway;
run;

*each table includes a list of the distinct values for the column along with a frequency count, percent, and cumulative frequency and percent;
proc freq data=sashelp.cars;
	tables origin type drivetrain;
run;
