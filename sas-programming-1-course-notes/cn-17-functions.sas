/*
The syntax for a function is the function name, followed by the arguments enclosed in parentheses. 
The arguments are separated by commas. 
The arguments consist of the input that the function needs to perform its specific routine and return a value.
	function(arg1, arg2,...)
	
A function is a routine that returns a value.
Functions can be used in an assignment statement to create or update a column.
	DATA output-table; 
		SET input-table;
		new-column=function(arguments); 
	RUN;
*/
/*
NUMERIC FUNCTIONS
	SUM (num1, num2, ...)
	MEAN (num1, num2, ...)
	MEDIAN (num1, num2, ...) 
	RANGE (num1, num2, ...)
	MIN (num1, num2, ...)
	MAX (num1, num2, ...)
	N (num1, num2, ...)
	NMISS (num1, num2, ...)

SAS has a collection of summary statistics functions, including SUM, MEAN, MEDIAN, and RANGE. 
Each of these functions can have an unlimited number of arguments, and each argument provides either a numeric constant or numeric column in the data. 
The function calculates the summary statistic from the values of the arguments for each row in the data. 
One interesting note about these summary functions is that if any of the input values are missing, the missing value or values are ignored, and the calculation is based on the known values.
*/

data cars_new; 
	set sashelp.cars;
	MPG_Mean=mean(MPG_City, MPG_Highway);
	format MPG_Mean 4.1;
	keep Make Model MPG_City MPG_Highway MPG_Mean;
run;

data storm_windavg;
    set pg1.storm_range;
    WindAvg=mean(wind1, wind2, wind3, wind4);
    WindRange=range(of wind1-wind4);
run;  
*Note: you can use the shorthand notation OF col1 - coln to list a range of columns when the columns have the same name and end in a consecutive number;


/*
CHARACTER FUNCTIONS
AS has many functions you can use to manipulate character columns. 
The arguments include one or more character columns in your data.
These are a few of the many character functions you can use:

Character Function						
	UPCASE (char)/LOWCASE(char)			Changes letters in a character string to uppercase or lowercase
	PROPCASE (char, <delimiters>)		Changes the first letter of each word to uppercase and other letters to lowercase
	CATS (char1, char2, ...) 			Concatenates character strings and removes leading and trailing blanks from each argument
	SUBSTR (char, position, <length>)	Returns a substring from a character string

Note: The default delimiters for the PROPCASE function are a blank, forward slash, hyphen, open parenthesis, period, and tab. 
	  To use a different list of delimiters, specify a list of characters in a single set of quotation marks as the second argument in the function. 

As a simple example, let’s look at the UPCASE function. 
It requires one argument: a character column. 
The UPCASE function returns the uppercase equivalent of the input data values. 
In this case, we are not creating a new column in the output data. 
We are converting the values in the Type column to uppercase in the cars_new data.
*/

data cars_new;
	set sashelp.cars;
	type=upcase(type);
	keep make model type;
run;

data storm_new;
 	set pg1.storm_summary;
 	drop Type Hem_EW Hem_NS MinPressure Lat Lon;
 	Basin=upcase(Basin);
 	Name=propcase(Name);
 	Hemisphere=cats(Hem_NS, Hem_EW);
 	Ocean=substr(Basin,2,1);
run;

data pacific;
    set pg1.storm_summary;
    drop type Hem_EW Hem_NS MinPressure Lat Lon;
    where substr(Basin,2,1)="P";
run;  

/*
DATE FUNCTIONS

These functions extract information from the SAS date column or value provided in the argument:
Date Function	
	MONTH (SAS-date)	Returns a number from 1 through 12 that represents the month
	YEAR (SAS-date)		Returns the four-digit year
	DAY (SAS-date)		Returns a number from 1 through 31 that represents the day of the month
	WEEKDAY (SAS-date)	Returns a number from 1 through 7 that represents the day of the week (Sunday=1)
	QTR (SAS-date)		Returns a number from 1 through 4 that represents the quarter

These functions enable you to create SAS date values from the arguments.
Date Function
TODAY ()							Returns the current date as a numeric SAS date value (no argument is required because the function reads the system clock)
MDY (month, day, year)				Returns a SAS date value from numeric month, day, and year values
YRDIF (startdate, enddate, 'AGE')	Calculates a precise age between two dates

Note: The optional third argument in the YRDIF function is called the basis. 
The basis value describes how SAS calculates a date difference or a person’s age. 
When calculating the age of a person or event, 'AGE' should be used as the basis

*/

data storm_damage2;
	set pg1.storm_damage;
 	drop Summary;
 	YearsPassed=yrdif(Date,today(),'age');
 	Anniversary=mdy(month(Date),day(Date),year(today()));
 	format YearsPassed 4.1 Date Anniversary mmddyy10.;
run;

data np_summary_update;
    set pg1.np_summary;
    keep Reg ParkName DayVisits OtherLodging Acres SqMiles Camping;
    SqMiles=Acres*.0015625;
    Camping=sum(OtherCamping,TentCampers, RVCampers,BackcountryCampers);
    format SqMiles comma6. Camping comma10.;
run;

data eu_occ_total;
    set pg1.eu_occ;
    Year=substr(YearMon,1,4);
    Month=substr(YearMon,6,2);
    ReportDate=MDY(Month,1,Year);
    Total=sum(Hotel,ShortStay,Camp);
    format Hotel ShortStay Camp Total comma17. ReportDate monyy7.;
    keep Country Hotel ShortStay Camp ReportDate Total;
run;

data np_summary2;
    set pg1.np_summary;
    ParkType=scan(parkname,-1);
    keep Reg Type ParkName ParkType;
run;

*Used the SCAN function to create a new column named ParkType that is the last word of the ParkName column.;
*Note: Use a negative number for the second argument to count words from right to left in the character string;