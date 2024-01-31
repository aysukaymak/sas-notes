/*
proc sort data=input-table <out=output-table> nodupkey <dupout=output-table>;
	by _ALL_;
run;

	_ALL_ sorts by all columns to ensure that duplicate rows are adjacent
	NODUPKEY removes adjacent rows with duplicate BY values
	DUPOUT output table of duplicates
*/

proc sort data=pg1.class_test3 out=test_clean nodupkey dupout=test_dups;
	by _all_;
run;
*remove the same rows like aysu math 96;

/*
PROC SORT DATA=input-table <OUT=output-table> NODUPKEY <DUPOUT=output-table>;
	BY <DESCENDING> col-name(s);
RUN;

keeps only the first occurrence of each unique value of the BY variable
*/


proc sort data=pg1.class_test2 out=test_clean dupout=test_dups nodupkey;
	by Name;
run;
*remove the same value in the column like aysu;

proc sort data=pg1.storm_detail out=storm_clean nodupkey dupout=storm_dups;
	by _all_;
run;

proc sort data=pg1.storm_detail out=min_pressure;
	where Pressure is not missing and Name is not missing;
	by descending Season Basin Name Pressure;
run;

proc sort data=min_pressure nodupkey;
	by descending season basin name;
run;

/*
To read only Geo and Country from the pg1.eu_occ table, you can use the KEEP= data set option. 
Add the KEEP= option immediately after the input table and list Geo and Country. 
Submit the program and verify that only one row per country is included.

data-set(KEEP=varlist)
*/
proc sort data=pg1.eu_occ(keep=geo country) out=countryList 
          nodupkey;
    by Geo Country;
run;
