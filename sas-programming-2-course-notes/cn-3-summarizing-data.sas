/*CREATING AN ACCUMULATING COLUMN
In the code below, the result values for YTDRain will all missing. 
Notice that the YTDRain assignment statement adds a missing value and dailyrain. 
If an arithmetic expression includes a missing value as input, the answer will be missing. 
This prevents you from creating the accumulating column.
*/

data houston_rain;
	set pg2.weather_houston;
	keep date dailyrain ytdrain;
	ytdrain=ytdrain+dailyrain;  *it returns all ytdrain values as missing;
run;

/*RETAINING VALUES IN THE PDV
In order to create an accumulating column, you must override the default behavior of the PDV. 
First, you must set the initial value of YTDRain to zero instead of missing. 
Second, when SAS reinitializes the PDV at the beginning of each iteration of the DATA step, you need to retain the value of YTDRain in the PDV instead of resetting it to missing each time. 
If these actions can be performed in the PDV, you can create an accumulating column.
For this;

	RETAIN column <initial-value>;

RETAIN is a compile-time statement that sets a rule for one or more columns to keep their value each time that the PDV is reinitialized instead of resetting the value to missing. 
It also provides the option of establishing an initial value in the PDV before the first iteration of the DATA step. 
By adding a RETAIN statement to a program, you can change the default behavior of the PDV in this scenario to create an accumulating column. 
*/

data houston2017;
	set pg2.weather_houston;
	retain ytdrain 0;
	ytdrain=ytdrain+dailyrain;
run;

data zurich2017;
	set pg2.weather_zurich;
	retain TotalRain 0;
	TotalRain=TotalRain+Rain_mm; *it returns missing values after the 5 row, because this time rain_mm value is missing in the fifth row;
run;

data zurich2017;
	set pg2.weather_zurich;
	retain TotalRain 0;
	TotalRain=sum(TotalRain, Rain_mm); *the sum function ignores missing values;
run;

/* SUM STATEMENT
You can use the sum statement as a simple way to create an accumulating column. 
The name of the new accumulating column is on the left, and the column to add for each row is on the right of the expression. 
The sum statement does the following four things automatically: 
	• creates the accumulating column on the left and sets the initial value to 0
	• automatically retains the value of the accumulating column in the PDV
	• adds the value of the column on the right to the accumulating column for each row
	• ignores missing values
		column+expression;
*/

data zurich2017;
	set pg2.weather_zurich;
	TotalRain+Rain_mm; *creating an accumulating column;
	DayNum+1;
run;

data parkTypeTraffic;
	set pg2.np_yearlytraffic;
	where ParkType in ("National Monument", "National Park");	
	if ParkType="National Monument" then MonumentTraffic+Count;
	else ParkTraffic+Count;
	format MonumentTraffic ParkTraffic comma15.;
run;
	
title "Accumulating Traffic Totals for Park Types";
proc print data=parktypetraffic;
	var ParkType ParkName Location Count MonumentTraffic ParkTraffic;
run;
title;

data cuyahoga_maxtraffic;
	set pg2.np_monthlytraffic;
	where ParkName eq "Cuyahoga Valley NP";
	retain TrafficMAx 0 MonthMax LocationMax;
	if Count>TrafficMax then do;
		TrafficMax=Count;
		MonthMax=Month;
		LocationMax=Location;
	end;
	format Count TrafficMax comma15.;
	keep Location Month Count TrafficMax MonthMax LocationMax;
run;

/* PROCESSING DATA IN GROUPS
If the input data is sorted in groups, the DATA step can process the data within groups. 
First you create an output table in the desired sort sequence based on groups. 
Then you use the BY statement in the DATA step to tell SAS that you want to process the data in groups.

For sorting the table into groups:
	proc sort data=input-table <out=sorted-otuput-table>;
		by <descending> col-name(s);
	run;

For proccessing the data in the sorted table by groups:
	data output-table;
		SET sorted-output-table;
		by <descending> col-name(s);  -->The BY statement creates First./Last. variables in the PDV that can be used to identify when each BY group begins and ends.
	run;

When a DATA step includes a BY statement followed by a column name, two special variables are added to the PDV: 
First.BY-column and Last.BY-column to indicate the first and last rows within each group. 
These variables are temporary and are dropped when the row is written to the output table.

During the execution phase, the First. and Last. variables are assigned a value of 0 or 1. 
The First. variable is 1 for the first row within a group and 0 for all other rows. 
Similarly, the Last. variable is 1 for the last row within a group and 0 for all other rows.
These temporary variables contain important information that we can use before the variables are dropped when the row is written to the output table.

*/

proc sort data=pg2.storm_2017 out=sorted_storm_2017 (keep=basin name);
	by basin;
run;

data storm_2017_max;
	set sorted_storm_2017;
	by basin;
	First_Basin=first.basin;
	Last_Basin=last.basin;
run;


proc sort data=pg2.storm_2017 out=storm2017_sort;
	by Basin MaxWindMPH;
run;

data storm2017_max;
	set storm2017_sort;
	by Basin;
	*where last.Basin=1; *it returns an error!;
	StormLength=EndDate-StartDate;
	MaxWindKM=MaxWindMPH*1.60934;
run;

/*SUBSETTING ROWS IN EXECUTION
The WHERE statement is a compile-time statement that establishes rules about which rows are read into the PDV.
The WHERE expression must be based on columns that exist in the input table referenced in the SET statement.
The values for the First. and Last. variables are not assigned until after a row is read into the PDV. 
Therefore, the WHERE statement does not work. 
Instead, you need to subset the data during the execution phase, based on values that can be assigned or changed after a row is read into the PDV.

The IF expression can be based on any values in the PDV.
The subsetting IF statement is an executable statement, so it processes during the execution phase in the order in which it occurs in the DATA step code. 
When the expression is true, the DATA step continues to execute the remaining statements in that iteration, including any explicit OUTPUT statements or the implicit output that occurs with the RUN statement. 
If the expression is not true, the DATA step immediately stops processing statements for that particular iteration, likely skipping the output trigger, and the row is not written to the output table.
	if expession; ---->SUBSETTING IF STATEMENT
	if expression then output;
	
This program uses the subsetting IF statement to delay evaluating the expression until the execution phase, when the First. and Last. variables are assigned values in the PDV. 
When the expression is true, meaning it is the last row for a particular Basin value, then SAS processes the StormLength and MaxWindKM assignment statements.
Then SAS comes to the RUN statement, which includes the implicit output and implicit return, and the contents of the PDV are written to the output table. 

When the subsetting IF condition is false, meaning it is not the last row for a particular Basin value, SAS skips the remaining statements, including the implicit output, and moves on to the next iteration of the DATA step. 
The subsetting IF statement not only filters the rows that are written to the output table but also prevents unnecessary statements from executing.

This program returns just 5 rows that each row is the last.Basin rows.
*/

data storm2017_max;
	set sorted_storm_2017;
	by basin;
	if last.Basin=1; *if condition is true, it continues to run statement. When reaches the run, occurs the implict output and implicit return;
					 *if condition is false, sas stop processing statements to run and occurs the implict returns;
	StormLength=EndDate-StartDate;
	MaxWindKM=MaxWindMPH*1.60934;
run;

/*ACCUMULATING COLUMN WITHIN GROUPS
How can we reset an accumulating column at the beginning of each group?
You can also use First. and Last. variables to prompt for some action to occur at the beginning or end of each group. 

Let’s look at our weather data for Houston. 
We created an accumulating total for the DailyRain column during the entire year using a sum statement, but what if we would like to create a month-to-date total column. 
In other words, we would like to create an accumulating column named MTDRain and reset it every time a new month begins.
*/

data houston_monthly;
	set pg2.weather_houston;
	keep date month dailyrain Mtdrain;
	by month;
	if first.month=1 then Mtdrain=0;
	Mtdrain+dailyrain;
run;
 
*for displaying the total raining value for each month:
data houston_monthly;
	set pg2.weather_houston;
	keep Date Month DailyRain MTDRain;
	by Month;
	if first.Month=1 then MTDRain=0;
	MTDRain+DailyRain;
	if last.Month=1;
run;       

/* MULTIPLE BY COLUMNS
If you sort data by more than one column, SAS arranges the data based on the first BY column, and it then sorts the second BY column within each unique value of the first BY column. 
If multiple columns are listed in the BY statement in the DATA step, then each column has its own First. and Last. variables in the PDV. 

The First. and Last. variables for Qtr indicate when a quarter begins and ends within a particular value of Year.
*/

data sydney_summary;
	set pg2.weather_sydney;
	by year qtr;
run;

proc sort data=pg2.np_yearlyTraffic out=sortedTraffic(keep=ParkType ParkName Location Count);
    by ParkType ParkName;
run;

data TypeTraffic;
    set sortedTraffic;
	by ParkType;
	if first.ParkType=1 then TypeCount=0;
	TypeCount+Count;
	if last.ParkType=1;
	format TypeCount comma12.2;
	keep ParkType TypeCount;	
run;

proc sort data=pg2.np_acres out=sortedAcres(keep=Region ParkName State GrossAcres);
	by Region ParkName;
run;
	
data multiState singleState;
	set sortedAcres;
	by Region ParkName;
	if first.ParkName=1 and last.ParkName=1 then output singleState;
	else output multiState;
	format GrossAcres comma15.;
run;
