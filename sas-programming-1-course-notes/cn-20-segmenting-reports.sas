/*
You can use the BY statement in a reporting procedure to segment a report based on the unique values of one or more columns.
For example, what if you want to generate a separate frequency report for each value of Origin?
You must sort the table by Origin first, and then use the BY statement in PROC FREQ.
Then SAS treats the rows for each value of Origin as a separate table and runs the frequency report.

!!The data must be sorted first before you use the BY statement in a reporting procedure.

*/
proc sort data=sashelp.cars out=cars_sort;
	by Origin;
run;

proc freq data=cars_sort;
	by Origin;
	tables Type;
run;

proc sort data=pg1.storm_final out=storm_sort;
	by BasinName descending MaxWindMPH;
	where MaxWindMPH > 156;
run;

title "Category 5 Storms";
proc print data=storm_sort label noobs; *suppress the OBS column;
	by BasinName;
	var Season Name MaxWindMPH MinPressure StartDate StormLength;
	label MaxWindMPH="Max Wind (MPH)" MinPressure="Min Pressure" 
		StartDate="Start Date" StormLength="Length of Storm (days)";
run;
title;