/*
simply type the name of the new column, an equal sign, and then the expression that creates a new data value.

DATA output-table;
	SET input-table;
	new-column = expression;
RUN;

The column name is stored in the case that you use to create it.

*/
data cars_new;
	set sashelp.cars;
	where origin ne "USA";
	Profit=MSRP-Invoice;
	Source="Non-US Cars";
	format Profit dollar10.;
	keep Make Model MSRP Invoice Profit Source;
run;

data tropical_storm;
	set pg1.storm_summary;
	drop Hem_EW Hem_NS Lat Lon;
	where Type="TS";
	MaxWindKM=MaxWindMPH*1.60934;
	format MaxWindKM 3.;
	StormType="Tropical Storm";
run;

data storm_length;
	set pg1.storm_summary;
    drop Hem_EW Hem_NS lat lon;
    StormLength = EndDate-StartDate+1;
run;