/* From cn-18-conditionals.sas — IF-THEN/ELSE with LENGTH to avoid truncation;
   IF-THEN/DO with multi-table OUTPUT */

data cars2;
	set sashelp.cars;
	length CarType $ 6;
	if MSRP<60000 then CarType="Basic";
	else CarType="Luxury";
	keep Make Model MSRP CarType;
run;

proc print data=cars2 (obs=15);
run;

proc freq data=cars2;
	tables CarType;
run;

/* IF-THEN/DO with output to multiple tables */
data under40 over40;
	set sashelp.cars;
	keep Make Model MSRP Cost_Group;
	if MSRP<20000 then do;
		Cost_Group=1;
		output under40;
	end;
	else if MSRP<40000 then do;
		Cost_Group=2;
		output under40;
	end;
	else do;
		Cost_Group=3;
		output over40;
	end;
run;

proc print data=under40;
run;

proc print data=over40;
run;
