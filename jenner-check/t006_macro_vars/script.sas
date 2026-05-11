/* From cn-11-sas-macro-variables.sas — %let creates macro vars, & references substitute the value */

%let CarType="Sedan";

proc print data=sashelp.cars;
	where Type=&cartype;
	var Type Make Model MSRP;
run;

proc means data=sashelp.cars;
	where Type=&cartype;
	var MSRP MPG_Highway;
run;

proc freq data=sashelp.cars;
	where Type=&cartype;
	tables Origin Make;
run;
