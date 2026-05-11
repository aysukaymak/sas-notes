/* From cn-17-functions.sas — numeric and character functions on sashelp.cars */

/* MEAN function across columns */
data cars_new;
	set sashelp.cars;
	MPG_Mean=mean(MPG_City, MPG_Highway);
	format MPG_Mean 4.1;
	keep Make Model MPG_City MPG_Highway MPG_Mean;
run;

proc print data=cars_new (obs=10);
run;

/* UPCASE on a column */
data cars_upper;
	set sashelp.cars;
	type=upcase(type);
	keep make model type;
run;

proc print data=cars_upper (obs=10);
run;

proc freq data=cars_upper;
	tables type;
run;
