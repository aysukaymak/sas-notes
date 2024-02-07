/*USING FUNCTIONS IN SAS
Many functions are included with Base SAS. 
A function accepts arguments, performs operations such as computations or text manipulations, and returns a numeric or character value.
A function can be called within an expression.

For ease of use, functions are divided into categories. 
Commonly used character functions include LENGTH, SUBSTR, FIND, and the CAT family of functions. 
Popular date and time functions include TODAY, MDY, YEAR, and DATEPART. 
The truncation category includes ROUND, INT, CEIL, and FLOOR. 
You've probably used descriptive statistics functions, including SUM, MEAN, MEDIAN, MIN, and MAX, and maybe the special functions PUT and INPUT.
	function(arg1, arg2,...);

CALL routines are similar to functions, in that they accept arguments and perform a computation or manipulation, but they differ from functions in that they don't return a value. 
Instead, they can alter variable values and perform system functions.
A CALL routine can't be called in an expression. 
You invoke it with a CALL statement and specify the name of the routine and its arguments. 
It can change the value of one or more arguments, in effect returning or passing multiple values to the calling code.
For example, the CALL MISSING routine assigns missing values to the columns that you pass as arguments. 
This is a convenient way to initialize multiple columns to missing.
	call routine(arg1, arg2, ...);

	call missing(of temp1-temp2);
	call missing(name, age, salary);
*/

/*USING LAG FUNCTION
Suppose you need to determine which city in China, Beijing or Shanghai, has the bigger difference in daily average temperatures between consecutive days. 
You have a table that contains daily average Celsius temperatures for 2017 for both cities. 
You need to compare the TavgC value from the current row to the value from the previous row. 
However, remember that a SAS DATA step processes one row at a time. How can you compare values from two rows?

You can use the LAG function. 
LAG maintains a queue of values for the requested column, enabling you to retrieve previous values.
	LAG<n>(column) 

If you use LAG or LAG1, you are looking for that column's value from the previous row. 
LAG2 gives you the previous value two rows back. LAG3 gives you the previous value three rows back, and so on. 
The LAG function is useful for computing differences between rows and computing moving averages.
	
	FirstPrevDay=lag1(TavgC);
	SecondPrevDay=lag2(TavgC);
	ThirdPrevDay=lag3(TavgC);
	FourthPrevDay=lag4(TavgC);
*/

data china_temps1;
	set pg3.weather_china_daily2017(keep=City Date TavgC);
	by City;
	FirstPrevDay=lag1(TavgC);
	SecondPrevDay=lag2(TavgC);
	ThirdPrevDay=lag3(TavgC);
	FourthPrevDay=lag4(TavgC);
run;

title 'Using LAG! through LAG4 Functions';
proc print data=china_temps1 noobs;
run;
title;

data china_temps;
    set pg3.weather_china_daily2017(keep=City Date TavgC);
	by City;
    TavgCPrevDay=lag1(TavgC);
	if first.City=1 then TavgCPrevDay=.;
    TempIncrease=TavgC-TavgCPrevDay;
run;

/*CALCULATING A MOVING AVERAGE
A moving average is an average calculated several times for different subsets of data.
For example, if you want a five-year moving average for the 2010 - 2017 data, you'd calculate averages for 2010 through 2014, 2011 through 2015, 2012 through 2016, and 2013 through 2017.

	Open3MntAvg=mean(Open, Open1MnthBack, Open2MntBack);
*/

data work.stockmovingavg;
    set pg3.stocks_ABC(drop=Close);
    Open1MnthBack=lag1(Open);
    Open2MnthBack=lag2(Open);
    Open3MnthAvg=mean(Open,Open1MnthBack,Open2MnthBack);
    format Open3MnthAvg 8.2;
run;

title 'Three Month Moving Average on Opening Stock Price'; 
proc print data=work.stockmovingavg noobs;
run;
title;

/*LAG WITH CONDITIONAL STATEMENTS
The LAG function stores previous values in a queue when the LAG function is executed. 
If the LAG function is not executed due to a false condition, the previous value is not stored. 
By using the LAG function outside of a conditional statement, the previous value is stored. 
*/

data stockmovingavg;
	set pg3.stocks_ABC(drop=close);
    Open1MnthBack=lag1(Open);
	Open2MnthBack=lag2(Open);
	if _N_ ge 3 then Open3MnthAvg=mean(Open,Open1MnthBack,Open2MnthBack);
	/*if _N_ ge 3 then Open3MnthAvg=mean(Open,lag1(Open), lag2(Open)); 
	A value is stored in the queue each time that the LAG function executes. 
	This conditional statement prevents LAG execution on the first two iterations of the DATA step, so there are no values in the queue for Jan or Feb. 
	The calls to LAG1 and LAG2 both return missing values, and the MEAN function ignores missing values, so the mean is calculated using only the value for March, 104.19.
	*/
    format Open3MnthAvg 8.2;
run;

title 'Three Month Moving Average on Opening Stock Price'; 
proc print data=stockmovingavg noobs;
run;
title;

data ParkTraffic2016;
    set pg3.np_2016traffic;
    by ParkCode;
	PrevMthTC=lag1(TrafficCount);
	if first.ParkCode=1 then PrevMthTC=.;
	OneMthChange=TrafficCount-PrevMthTC;
run;

title '2016 National Park Traffic Counts';
proc print data=ParkTraffic2016;
run;

/*USING COUNT FUNCTIONS
The COUNT function counts the number of times that a specified substring appears within a character string. 
The COUNTC function counts the number of characters in a string that appear (or don't appear) in a list of characters. 
The COUNTW function counts the number of words in a character string. 
There are slight differences in syntax for the three functions.

	COUNT(string, substring <, modifier(s)>);
	COUNTC(string, character-list <, modifier(s)>);
	COUNTW(string <, delimiter(s)> <, modifier(s)>);

		NumEF=count(Narrative, 'EF'); ---> count the number of times that the string EF is found in the Narrative column.
		NumWord=countw(Narrative, ' '); ---> count the number of words within the Narrative column.
		
The second argument to COUNTW specifies the delimiter or delimiters that separate words.
The default list of delimiters is used if the second argument is omitted. 
	blank ! $ % & () * + , - . / ; < ^ |
*/
/*USING FIND FUNCTIONS
SAS offers several FIND functions to search for a substring within a string.
The FIND function returns the starting position of the first occurrence of a substring within a string. 
FINDC returns the starting position where a character from a list of characters is found in a string.
FINDW returns either the starting position of a word in a string or the number of the word in a string.

	FIND(string, substring <, modifier(s)> <, start-position>) 
	FINDC(string, character-list <, modifier(s)> <, start-position>) 
	FINDW(string, word, <, delimiter(s)> <, modifier(s)> <, start-position>) 

	EFWordNum=findw(Narrative, 'EF', '012345- .,', 'e')
The first argument, Narrative, is the string that we want to search, and the second argument is the word that we're searching for, 'EF'. 
For the third argument, we need to specify the specific delimiters that separate words. 
Recall that EF might be immediately followed by a number, 1 through 5, or a hyphen, or maybe a space, a period, or even a comma. 
So we specify all of these as possible delimiters. 
We specify the modifier e as the fourth argument, to count the number of words that are scanned until the specified word is found. 
The e modifier returns the number of the word in the string instead of returning its starting position. 
The modifier can be specified in lowercase or uppercase, but it must be positioned after the delimiter argument.
When we have the word number for the EF value, we can use the SCAN function to extract the word that follows it.
*/

data narrative;
    set pg3.tornado_2017narrative;
	NumEF=count(Narrative, 'EF');
	NumWord=count(Narrative, ' ');
	EFStartPos=find(Narrative, 'EF');
	EFWordNum=findw(Narrative, 'EF', '012345- .,', 'e'); 
	if EFWordNum>0 then 
       AfterEF=scan(Narrative,EFWordNum+1,'012345- .,');
run;

proc print data=narrative;
run;

proc means data=narrative maxdec=2;
    var NumEF NumWord ;
run;

proc freq data=narrative order=freq;
    tables AfterEF;
run;

data SouthRim;
	set pg3.np_grandcanyon;
	NumSouth=count(Comments, 'South', 'i');
	if NumSouth>0;
	SouthWordPos=findw(Comments, 'South', ' .', 'ei');
	AfterSouth=scan(Comments, SouthWordPos+1, ' .');
run;

title 'Grand Canyon Comments Regarding South Rim';
proc print data=SouthRim;
run;
title;

data Mammal_Names;
    set pg3.np_mammals(keep=Scientific_Name Common_Names);
    SpecCharNum=countc(Common_Names,',/*');
    if SpecCharNum=0 then do;
       Name=Common_Names;
       output;
    end;
    else do i=1 to SpecCharNum+1;
       Name=scan(Common_Names,i,',/*');	
       output;
    end;
run;

title 'National Park Mammals';
proc print data=Mammal_Names;
run;
title;
