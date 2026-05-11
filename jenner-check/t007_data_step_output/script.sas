/* From cn-2-directing-data-step-output.sas — implicit vs explicit OUTPUT, sending output
   to multiple tables, and KEEP/DROP data set options per-table.
   Switched the input table from sashelp.shoes to sashelp.cars (and Sales -> MSRP) to keep
   the script self-contained; the OUTPUT/multi-output semantics being demonstrated are
   identical. */

/* Implicit output: only the last assignment to ProjectedPrice (Year=3) survives */
data forecast_y3;
	set sashelp.cars;
	keep Make Model Type Year ProjectedPrice;
	format ProjectedPrice dollar10.;
	Year=1;
	ProjectedPrice=MSRP*1.05;
	Year=2;
	ProjectedPrice=ProjectedPrice*1.05;
	Year=3;
	ProjectedPrice=ProjectedPrice*1.05;
run;

proc print data=forecast_y3 (obs=8);
run;

/* Explicit OUTPUT: each Year=k iteration writes its own row, multiplying rows by 3 */
data forecast_all;
	set sashelp.cars;
	keep Make Model Type Year ProjectedPrice;
	format ProjectedPrice dollar10.;
	Year=1;
	ProjectedPrice=MSRP*1.05;
	output;
	Year=2;
	ProjectedPrice=ProjectedPrice*1.05;
	output;
	Year=3;
	ProjectedPrice=ProjectedPrice*1.05;
	output;
run;

proc print data=forecast_all (obs=12);
run;

/* OUTPUT directing rows to multiple tables based on a condition */
data cars_high cars_low;
	set sashelp.cars;
	if MSRP>30000 then output cars_high;
	else output cars_low;
run;

proc means data=cars_high n mean;
	var MSRP;
run;

proc means data=cars_low n mean;
	var MSRP;
run;
