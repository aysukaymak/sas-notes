/*SAS FUNCTION
A SAS function is a named, predefined process that can be used in a SAS program to produce a value. 
The function might accept none, one, or several arguments as input. Based on the arguments, the function performs its specified computation or manipulation and returns a value.

	function(arg1,arg2,..);

A function performs a specific computation or manipulation and returns a value.
A function returns a value that must be used in an assignment statement or expression.
*/

data quiz_summary;
	set pg2.class_quiz;
	Name=upcase(Name);
	*M1, M2 and M3 returns the same value;
	Mean1=mean(Quiz1, Quiz2, Quiz3, Quiz4, Quiz5);
	/* Numbered Range: col1-coln where n is a sequential number */ 
	Mean2=mean(of Quiz1-Quiz5);
	/* Name Prefix: all columns that begin with the specified character string */ 
	Mean3=mean(of Q:);
run;

/* SPECIFYING COLUMN LIST
You can use a double dash to represent a physical range of columns as they are ordered in the data. 
This FORMAT statement formats all columns from left to right from Quiz1 to AvgQuiz with the 3.1 format. 

You could also use the keyword _NUMERIC_ to include all numeric columns with the 3.1 format. 
You can also use the keywords _CHARACTER_ and _ALL_ to group columns. 

You do not need to use the OF keyword in the FORMAT statement. 
That is a special requirement when you use column lists as arguments in a function or CALL routine. 
*/

data quiz_summ;
	set pg2.class_quiz;
	Name=upcase(Name);
	AvgQuiz=mean(of Q:);
	format quiz1--AvgQuiz 3.1; *The double dash includes all columns between and including the two specified columns as they are ordered in the PDV;
	*format _numeric_ 3.1; *The keyword _NUMERIC_ includes all numeric columns;
run;

/* SAS COLUMN LISTS
Numbered range lists 	
x1-xn  				Specifies all columns from x1 to xn inclusive. 
					You can begin with any number and end with any number as long as you do not violate the rules for user-supplied column names and the numbers are consecutive.
-----------------------------------------------------------------------------------------------
Name range lists		
x - - a				Specifies all columns ordered as they are in the program data vector, from x to a inclusive.
x-numeric-a 		Specifies all numeric columns from x to a inclusive.
x-character-a		Specifies all character columns from x to a inclusive.
-----------------------------------------------------------------------------------------------
Name prefix lists 	
REV: 				Specifies all the columns that begin with REV, such as REVJAN, REVFEB, and REVMAR.
-----------------------------------------------------------------------------------------------
Special SAS name lists			
_ALL_ 				Specifies all columns that are already defined in the current DATA step.
_NUMERIC_ 			Specifies all numeric columns that are already defined in the current DATA step.
_CHARACTER_ 		Specifies all character columns that are already defined in the current DATA step.
*/

/*SAS CALL ROUTINE
A CALL routine also performs a computation or a system manipulation based on input that you provide in arguments. 
However, a CALL routine does not return a value. Instead, it alters column values or performs other system functions. 
In order for a CALL routine to be able to modify the value of an argument, those arguments must be supplied as column names. 
Constants and expressions are not valid.
All SAS CALL routines are invoked with CALL statements. 
In other words, the name of the routine must appear after the keyword CALL in the CALL statement.

	call routine(arg1, arg2,...);

They cannot be used in assignment statements or expressions. 

Suppose you have a class of students that have taken five quizzes, and you want to drop each student’s lowest two quiz scores and base their grade on the average of the top three scores. 
The CALL SORTN routine takes the columns provided as arguments and reorders the numeric values from low to high. 
Notice that the data values are not assigned to new columns, but instead they are reordered in the existing columns. 
The mean score is then calculated based on the values of Quiz3 through Quiz5. 
*/

data quiz_report;
	set pg2.class_quiz;
	call sortn(of Quiz1-Quiz5); *CALL SORTN sorts the values of the columns in ascending order;
	QuizAvg=mean(of Quiz3-Quiz5);
run;

data quiz_report;
    set pg2.class_quiz;
	if Name in("Barbara", "James") then do;
		Quiz1=.;
		Quiz2=.;
		Quiz3=.;
		Quiz4=.;
		Quiz5=.;
	end;
run;

data quiz_report;
	set pg2.class_quiz;
	if name in ("Barbara", "James") then call missing(of Q:);
run;
	

/* USING NUMERIC and DATE FUNCTIONS
calculate summary statistics:
SUM(num1, num2, …)
MEAN(num1, num2, …)

extract information from SAS date values:
YEAR(SAS-date)
MONTH(SAS-date)

create SAS date values:
TODAY(SAS-date)
MDY(month,day,year)

Suppose you have a table that includes student names and five quiz grades, and you want to create an output table that includes only the top three quiz scores, an average of the top three scores, and a randomly generated number for each student. You can use several numeric functions to do this. 
	
	The RAND function can be used to assign a random number to each student:
	RAND('distribution', param1, param2,...);

	The LARGEST function can be used to identify the kth largest nonmissing value.
	LARGEST(k, value1, value2,..);

	The SMALLEST function can be used to identify the kth smallest nonmissing value.
	SMALLEST(k, value1, value2,..);

	The MEAN and ROUND functions can be used to calculate the average value with one decimal place.
	ROUND(number <, rounding-unit>)
*/

data quiz_analysis;
	StudentID=rand("integer", 1000, 9999); *Because you placed the assignment statement before the SET statement, StudentID is the first column added to the PDV and the leftmost column in the output table;
	set pg2.class_quiz;
	drop Quiz1-Quiz5;
    Quiz1st=largest(1, of Quiz1-Quiz5);
	Quiz2st=largest(2, of Quiz1-Quiz5);
	Quiz3st=largest(3, of Quiz1-Quiz5);

	Top3Avg=round(mean(Quiz1st, Quiz2st, Quiz3st)); *to round the values returned by the MEAN function to the nearest integer;
	*Top3Avg=round(mean(Quiz1st, Quiz2st, Quiz3st), .1); *it can be used with specifying the decimal number;
	drop quiz1-quiz5 name;
run;

data stays;
	set pg2.np_lodging;
	stay1=largest(1, of CL:);
	stay2=largest(2, of CL:);
	stay3=largest(3, of CL:);
	
	stayAvg=round(mean(of CL:));
	if stayAvg > 0;
	format Stay: comma11.;
	keep Park Stay:;
run;

/* CHANGING NUMERIC PRECISION
There are other functions that eliminate the decimal places and convert a numeric value to an integer.
The CEIL function rounds each number up to the nearest integer, and the FLOOR function rounds each number down to the nearest integer. 
There is also the INT function, which simply truncates the number and returns the integer portion only.

CEIL(number) 	Returns the smallest integer that is greater than or equal to the argument
FLOOR(number) 	Returns the largest integer that is less than or equal to the argument
INT(number) 	Returns the integer value 
*/

/* DATE, DATETIME, TIME VALUES

SAS date		date		01Jan1960		date
				-n 				0 			  n --> number of days

SAS time		00:00						time
			  	  n 						  0 --> number of seconds

SAS datetime	datetime	01Jan1960		datetime
				  -n 			0 			  n --> number of seconds

Dates in SAS are stored as a number that represents the number of days since January 1, 1960. 
It is possible for data to also include times, or a combination of dates and times. 
A time value in SAS is stored as the number of seconds from midnight. 
A datetime value in SAS is stored as the number of seconds from midnight on January 1, 1960. 
Just like SAS date values, this numeric storage method enables you to calculate time between two events, or sort by time or datetime.
*/

/* EXTRACTING DATA FROM A DATETIME VALUE
There are many formats that enable SAS to display both the date and time component, but what if you want to separate the date or time value and create new columns? 
This can be accomplished easily with either the DATEPART or TIMEPART function. 
The only required argument is a SAS datetime value. 
After the date or time component is isolated, you can use any relevant date or time formats or functions to further enhance or manipulate the values.
In this example, the DATEPART and TIMEPART functions are used to create two new columns, WindDate and WindTime. 
The functions return raw SAS date and SAS time numeric values, which can then be formatted to improve the display.
	
	DATEPART(datetime-value);
	TIMEPART(datetime-value);
		
*/

data storm_details;
	set pg2.storm_detail;
	windDate=datepart(ISO_Time);
	windTime=timepart(ISO_Time);
	format windDate date9. windTime time.;
run;

/* CALCULTATING DATE INTERVALS
Suppose we need to count the number of time intervals, such as weeks, weekdays or months, that have occurred between a start date and an end date? 
The INTCK function returns the number of interval boundaries of a given time period that occur between two dates.

	INTCK('interval', start-date, end-date <, 'method'>);
		interval: interval that you want to count. (week, month, year, weekday, hour)
		method: 'discrete' or 'd' --> Each interval has a fixed boundary. For example, a week ends after Saturday, or a year ends on December 31
				'continuous' or 'c' --> Each interval is measured relative to the start date or time.

Discrete method is default.
*/

data storm_length;
	set pg2.storm_final(obs=10);
	keep Season Name StartDate Enddate StormLength Weeks;
	Weeks=intck('week', StartDate, EndDate, 'c');
run;

/*SHIFTING DATE VALUES
You can use the INTNX function for adjusting or shifting date values. 
This function enables you to select an interval (such as week, month, year, or many others) as the first argument, and name a SAS date column as the second argument. 
The third argument is the increment number, which represents the number of intervals to shift the value of the start date. 
The optional fourth argument controls the position of SAS dates within the interval.

	INTNX(interval, start, increment <, 'alignment'>)
		if increment is 0, it returns the current month/week/year's first day.
						-1, it returns the last month/year/week
		aligment can be middle, same, end
*/

data storm_damage2;
	set pg2.storm_damage;
	keep Event Date AssessmentDate;
	AssessmentDate=intnx('month', Date, -1); 
    format Date AssessmentDate date9.;
run;

data rainsumm;
	set pg2.np_hourlyrain;
	by month;
	if first.Month=1 then MonthlyRainTotal=0;
	MonthlyRainTotal+Rain;
	if last.Month=1;
	Date=datepart(DateTime);
	MonthEnd=intnx('month', Date, 0, 'end');
	format Date MonthEnd date9.;
	keep StationName MonthlyRainTotal Date MonthEnd;
run;

/*CHARACTER FUNCTIONS

UPCASE(char)
PROPCASE(char, <delimiters)
SUBSTR(char, position <,length>)

COMPBL(string) 	Returns a character value with all multiple blanks in the string converted to single blanks 
COMPRESS (string <, characters>) 	Returns a character value with specified characters removed from the string
STRIP(string) 	Returns a character value with leading and trailing blanks removed from the string

*/

data weather_japan;
	set pg2.weather_japan;
	NewLocation=compbl(Location);
	*NewStation=compress(Station);  *blanks will be removed;
	NewStation=compress(Station, '-');
run;

/* EXTRACTING WORDS FROM A STRING
The SCAN function extracts a particular word in sequence from a string. 
You provide a character column as the first argument, and the word number that you want to extract as the second argument. 
The optional third argument enables you to control the characters that are treated as delimiters, indicating when words begin and end.
	
	City=scan(Location,1);

The SCAN function treats the following characters as delimiters: blank ! $ % & ( ) * + , - . / ; < ^ | 
By default, SAS uses the default delimiter list, so each of these characters indicates the end of one word and the beginning of the next word.
*/

data weather_japan_clean;
	set pg2.weather_japan;
	Location=compbl(Location);
	City=propcase(scan(Location, 1, ','), ' ');
	Prefecture=scan(Location, 2, ',');
	Country=scan(Location, -1);
run;

/*SEARCHING FOR CHARACTER STRING
The FIND function searches for a particular substring within character values. The FIND function returns a number that represents the first character position where substring is found in string.
The first argument typically is the character column, and the second argument specifies the substring to find. 
The optional third argument can be used to provide character modifiers. 
I makes the search case insensitive, and T trims leading and trailing blanks.
The FIND function returns a number that indicates the start position of the substring within the string. 
If the substring is not found, the FIND function returns a zero.

	airportloc=find(Station, 'Airport');

FINDC	Searches a string for any character in a list of characters.
FINDW	Returns the character position of a word in a string, or returns the number of the word in a string.
*/

data storm_damage2;
	set pg2.storm_damage;
	drop Date Cost;
	CategoryLoc=find(Summary, 'category', 'I');
	if CategoryLoc > 0 then Category=substr(Summary,CategoryLoc, 10);
run;

proc print data=storm_damage2;
	var Event Summary Cat:;
run;

/*IDENTIFYING CHARACTER POSITIONS
Similar to the FIND function, there are many other functions that return a numeric value that identifies the location of selected characters.
The LENGTH function returns a number that is the position of the last non-blank character in a string. 
There are several ANY functions that return the first position of a particular type of character, such as a digit, alpha or punctuation character.
	
LENGTH(string) 		Returns the length of a non-blank character string, excluding trailing blanks; returns 1 for a completely blank string
ANYDIGIT(string) 	Returns the first position at which a digit is found in the string 
ANYALPHA(string) 	Returns the first position at which an alpha character is found in the string
ANYPUNCT(string)	Returns the first position at which punctuation (noktalama) character is found in the string

LENGTHC 				Returns the length of a character string, including trailing blanks.
LENGTHN 				Returns the length of a character string, excluding trailing blanks.
ANYLOWER/ANYUPPER		Searches a character string for a lowercase (or uppercase) letter, and returns the first position at which the letter is found.
ANYSPACE 				Searches a character string for a whitespace character (blank, horizontal and vertical tab, carriage return, line feed, and form feed), and returns the first position at which that character is found.
*/

/*REPLACING CHARACTER STRINGS
The TRANWRD function basically does find and replace for you. 
The first argument is usually a character column, the second argument is the target, or the string that you want to find. 
The third argument is the string that replaces the target. 
This assignment statement uses the TRANWRD function to replace all instances of lowercase hurricane with storm in the Summary column.

	TRANWRD(source, target, replacement);

	sum2=trandwrd(Summary, 'hurricane', 'storm');

TRANSLATE 	Searches a string for any character in a list of characters.
TRANSTRN 	Replaces or removes all occurrences of a substring in a character string.
*/

/*BUILDING CHARACTER STRINGS
You can use concatenation functions to combine strings into a single character value. 
The arguments can be either character or numeric values.
 The CAT function combines the strings as is without removing leading or training blanks. 
CATS combines strings and removes blanks. 
CATX combines strings, removes blanks, and inserts a delimiter that you specify between each string. 
Character strings can also be concatenated using the concatenation operator (||). 
The concatenation operator does not trim leading or trailing blanks. 
Use the STRIP or TRIM function to remove trailing blanks from values before concatenating them

CAT(string1, ... stringn) 		Concatenates strings together, does not remove leading or trailing blanks
CATS(string1, ... stringn) 		Concatenates strings together, removes leading or trailing blanks from each string
CATX('delimiter', string1, ... stringn) 	Concatenates strings together, removes leading or trailing blanks from each string, and inserts the delimiter between each string
*/

data storm_id;
	set pg2.storm_final;
	keep StormID: ;
	Day=StartDate-intnx('year', StartDate, 0);
	StormID1=cat(Name, Season, Day);
	StormID2=cats(Name, '-', Season, Day);
	StormID3=catx('-', Name, Season, Day);
run;

data clean_traffic;
	set pg2.np_monthlytraffic;
	drop year;
	length Type $5;
	type=scan(Parkname, -1);
	region=upcase(compress(region));
	location=propcase(location);
run;

data parks;
	set pg2.np_monthlytraffic;
	where parkname like '%NP';
	park=substr(Parkname, 1, find(Parkname,'NP')-2);
	location=compbl(propcase(location));
	gate=tranwrd(location, 'Traffic Count At', ' ');
	gatecode=catx('-', Parkcode, gate);
run;

/*AUTOMATIC CONVERSION OF COLUMN TYPE
If an arithmetic calculation is performed on a character value, SAS automatically attempts to convert the values for the purpose of evaluating the expression. 
Sometimes the automatic conversion is successful, as it is with the High column. 
Because High includes only standard numeric values (just digits and decimal points), SAS is able to interpret the character strings as numbers. 
	high 89.98 low 81.56

Sometimes the automatic conversion does not work, like with the Volume column. 
The values of Volume include commas, resulting in missing values when automatic conversion is attempted. 
	volume 5,025,627
	
Similarly, if you use a numeric column in a character expression, SAS attempts to convert the values. 
Sometimes it works just fine, and other times you can get unexpected results. 
*/

data work.stocks2;
   set pg2.stocks2;
   Range=High-Low;
   *DailyVol=Volume/30;
run;

/*CONVERSION FUNCTIONS
INPUT(source, informat) 	Converts character values to numeric values using a specified informat.
							An informat is used to indicate how the character string should be read.
PUT(source, format) 		Converts numeric or character values to character values using a specified format to indicate how the values should be written. 

	date2=input(Date, date9.)
		15OCT2018 		DATE9. 		21472
		10/15/2018 		MMDDYY10. 	21472
		15/10/2018 		DDMMYY10. 	21472
		123,456.78 		COMMA12. 
		$123,456.78 	DOLLAR12. 	123456.78
		123456 			6. 			123456
The informat specifies how the character value looks so that it can be converted to a numeric value.
The multipurpose `ANYDTDTEw.` informat can read dates written in many ways.
If a date is ambiguous, such as 6/1/2018 (which can be interpreted as either June 1 or January 6), SAS uses the DATESTYLE= system option to determine the sequence.
The default value for the DATESTYLE= option is determined by the value of the LOCALE= system option.
For example, if LOCALE= is English, then the DATESTYLE= order is MDY, so 6/1 would be read as June 1. 
	options datesytle=MDY; (default)
					 =DMY;

The Date column has been defined as character. Dates are best stored as numeric values that reference the number of days since January 1, 1960. 
The INPUT function is used to read the character value from Date and convert it to a numeric value. 
The INPUT function has two arguments. The first argument is the source or the column that needs to be converted. 
The second argument is the informat. The informat tells SAS how the data in the input table is displayed.
*/

data stocks2;
	set pg2.stocks2;
	Date2=input(Date, ANYDTDTE9.);
	Volume2=input(Volume, comma12.);
	*Volume=input(Volume,comma12.); *Volume is still character. Assignment statement not changing the column type. Volume cannot be in the PDV as both numeric and character. The character attribute of Volume from the SET statement is controlling the column type;
run;

/*CONVERTING THE TYPE OF AN EXISTING COLUMN
When the SET statement reads the pg2.stocks data, the PDV is established and Volume is a character column. 
The assignment statement cannot change the character column Volume to a numeric column. 
This is similar to how a LENGTH statement has no effect after the length of a column is set in the PDV. 
If you want to change Volume to a numeric column, there are three steps that you must follow to change the column type.

First, use the RENAME= data set option in the SET statement to rename the input column that you want to change. 
The RENAME= data set option follows the table name in the SET statement. 
Then you list the current column name on the left of the equal sign and the new column name on the right.
	table (RENAME=(current-col-name=new-col-name))

In this example, Volume is renamed as CharVolume. CharVolume is added to the PDV as a character column.
Next, in an assignment statement, use the INPUT function with the renamed column as the source. 
To the left of the equal sign, use the original column name that you want to be numeric. 
This adds Volume to the PDV as a numeric column.
Finally, use a DROP statement to eliminate the renamed column from the output table.
*/

data work.stocks2;
	set pg2.stocks2(rename=(Volume=CharVolume));
	Date2=input(Date,date9.);
	Volume=input(CharVolume, comma12.);
	drop CharVolume;
run; 

/*Converting Numeric Values to Character Values
The INPUT function converts columns from character to numeric. 
The PUT function can be used to do the opposite: to convert a numeric value to a character value. 
The PUT function has two arguments. The first argument is the source, which is the column that you want to convert from numeric to character. The second argument is the format. 
The format tells SAS how to display the new character value.
Suppose you have a numeric Date column and want to create a Day column that has the first three letters of the day of the week for the particular date. 
The PUT function reads the numeric value in Date and converts it to character using the format DOWNAME3.
	day=put(Date, downame3.);

	21472 		DATE9. 			15OCT2018
	21472 		DOWNAME3. 		Mon
	21472 		YEAR4. 			2018
	123456.78 	COMMA10.2 		123,456.78
	123456.78 	DOLLAR11.2 		$123,456.78 
	123.456 	6.2 			123.46
The format specifies how the numeric value should look as a character value.
*/

data atl_precip;
 	set pg2.weather_atlanta(rename=(Date=CharDate));
 	where AirportCode='ATL';
	drop AirportCode City Temp: ZipCode Precip CharDate;
 	if Precip ne 'T' then PrecipNum=input(Precip,6.);
 	else PrecipNum=0;
 	TotalPrecip+PrecipNum;
 	Date=input(CharDate,mmddyy10.);
 	format Date date9.;
run;

data work.weather_atlanta;
 	set pg2.weather_atlanta;
 	CityStateZip=catx(' ',City,'GA',ZipCode);
 	ZipCodeLast2=substr(put(ZipCode,z5.), 4, 2);
run;

data work.stocks2;
    set pg2.stocks2(rename=(Volume=CharVolume Date=CharDate));
    Volume=input(CharVolume,comma12.);
    Date=input(CharDate,date9.);
    drop Char:;
run;
