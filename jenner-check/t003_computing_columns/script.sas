/* From cn-16-computing-new-columns.sas — calculate a new column with format and KEEP */

data cars_new;
	set sashelp.cars;
	where origin ne "USA";
	Profit=MSRP-Invoice;
	Source="Non-US Cars";
	format Profit dollar10.;
	keep Make Model MSRP Invoice Profit Source;
run;

proc print data=cars_new (obs=15);
run;

proc means data=cars_new;
	var MSRP Invoice Profit;
run;
