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

