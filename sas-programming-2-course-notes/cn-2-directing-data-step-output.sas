/*
data output-table;
	set input-table;
	...other statements...
run; 
When exe. phase is reached the run statement, implict OUTPUT and implict RETURN are occured.

The DATA step provides syntax that enables you to control exactly how the steps of execution proceed.
Suppose we want to create a table that includes a sales forecast for each of the next three years, assuming that sales increase by 5% annually.

*/

*Final values in the PDV and output table are Year=3 and ProjectedSales for year 3. So for each step in data step processing loop is repeated 3 times but just the year=3 is printed;
*The output table contains 395 rowws;
data forecast;
	set sashelp.shoes;
	keep Region Product Subsidiary Year ProjectedSales;
	format ProjectedSales dollar10.;
	Year=1;
	ProjectedSales=Sales*1.05;
	Year=2;
	ProjectedSales=ProjectedSales*1.05;
	Year=3;
	ProjectedSales=ProjectedSales*1.05;
run;

/*
By default, SAS sequentially executes all appropriate statements in the DATA step, and when it reaches the end of the DATA step, it implicitly outputs the data in the PDV as a row in the output table. 
Then SAS automatically loops back to the top of the DATA step and goes through the same process for the next row. 
In this program, although the value of ProjectedSales is calculated for years 1, 2, and 3, the implicit output occurs only once at the bottom of the loop. 
When SAS reaches the end of the DATA step, the values in the PDV are for year 3, and those values are written to the output table. 
*/

/* EXPLICIT OUTPUT
You can use an explicit OUTPUT statement in the DATA step to force SAS to write the contents of the PDV to the output table at specific points in the program. 
If you use an explicit OUTPUT statement anywhere in a DATA step, there is no implicit output at the end of the DATA step. The implicit return still returns processing to the top of the DATA step. 

data forecast;
	set sashelp.forecast;
	....
	output;
run; 
Just occurs implict return!!
*/

*Final values in the PDV and output table are Year=1, Year=2, Year=3 and ProjectedSales for year 1,2,3. So for each step in data step processing loop is repeated 3 times but this time  all of the years are printed;
*The output table contains 3*395=1185 rows;
*If comment the last output statement, the output table just will contain the year 1 and 2 values;
data forecast;
	set sashelp.shoes;
	keep Region Product Subsidiary Year ProjectedSales;
	format ProjectedSales dollar10.;
	Year=1;
	ProjectedSales=Sales*1.05;
	output;
	Year=2;
	ProjectedSales=ProjectedSales*1.05;
	output;
	Year=3;
	ProjectedSales=ProjectedSales*1.05;
	*output;
run;

/* SENDING OUTPUT TO MULTIPLE TABLES
The OUTPUT statement controls when to output, but one of the great features is that it also controls where to output. 
The DATA step can create multiple tables simultaneously simply by listing more than one table in the DATA statement.
You can use the OUTPUT statement followed by the name of the table to indicate where SAS should write the contents of the PDV. 

	data table1 <table2...>;
	output table1 <table2...>;
*/

data sales_high sales_low;
	set sashelp.shoes;
	if sales>100000 then output sales_high;
	else output sales_low;
run;

data indian atlantic pacific; 
	set pg2.storm_summary_small;
	length ocean $ 8;
	where Name is not missing;
	Basin=upcase(Basin);
	StormLength=EndDate-StartDate;
	MaxWindKM=MaxWindMPH*1.60934;
	
	if substr(Basin, 2, 1)="I" then do;
		Ocean="Indian";
		output indian;
	end;
	else if substr(Basin, 2, 1)="A" then do;
		Ocean="Atlantic";
		output atlantic;
	end;
	else do;
		Ocean="Pacific";
		output pacific;
	end;
run;

/* CONTROLLING COLUMN OUTPUT
When you use a DROP or KEEP statement in the DATA step, the column is flagged for dropping or keeping in the PDV, so the action applies to all of the tables listed in the DATA statement.
You can use the DROP= or KEEP= data set options to specify a unique list of columns for each table listed in the DATA statement. The PDV keeps track of columns to drop from the specific output table. 

table(DROP=col1 col2...)
table(KEEP=col1 col2...)

CONTROLLING COLUMN INPUT
When you use a DROP= or KEEP= data set option on a table in the SET statement, the excluded columns are not read into the PDV and are not available for processing. 
It does not delete columns from the original data.

SET table(DROP=col1 col2...)
SET table(KEEP=col1 col2...)

When you use a DROP or KEEP statement or a DROP= or KEEP= data set option in the DATA statement, the columns are included in the PDV and can be used for processing. 
They are flagged to be dropped when an implicit or explicit output is reached.
*/


data sales_high(drop=returns) sales_low(drop=inventory);
	set sashelp.shoes;
	*drop inventory returns;
run;

data indian(drop=maxwindmph) atlantic(drop=maxwindkm) pacific; 
	set pg2.storm_summary(drop=minpressure);
	length ocean $ 8;
	where Name is not missing;
	Basin=upcase(Basin);
	StormLength=EndDate-StartDate;
	MaxWindKM=MaxWindMPH*1.60934;
	
	if substr(Basin, 2, 1)="I" then do;
		Ocean="Indian";
		output indian;
	end;
	else if substr(Basin, 2, 1)="A" then do;
		Ocean="Atlantic";
		output atlantic;
	end;
	else do;
		Ocean="Pacific";
		output pacific;
	end;
run;

data camping(keep=ParkName Month DayVisits CampTotal) logging(keep=ParkName Month DayVisits LodgingOther);
	set pg2.np_2017;
	CampTotal=sum(of camping:) *CampingOther+CampingTent+CampingRV+CampingBackcountry;
	format CampTotal COMMA15.1;
	if CampTotal>0 then output camping;
	else if LodgingOther > 0 then output logging;
run;

data monument(drop=ParkType) park(drop=ParkType) other;
	set pg2.np_yearlytraffic;
	select (ParkType);
		when ('National Monument') output monument;
		when ('National Park') output park;
		otherwise output other;
	end;
	drop region;
run;