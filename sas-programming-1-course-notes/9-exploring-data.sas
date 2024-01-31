/*
Exploring data can include learning about the columns and values that you have, 
as well as validating data to look for incorrect or inconsistent values.

After accessing data, the next step is to understand it. 
PROC CONTENTS can be used to confirm column attributes, but often the data is too large or complex for a visual review to be sufficient. 
The PRINT, MEANS, UNIVARIATE, and FREQ procedures can be used to quickly and easily explore data. 

	PRINT: Creates a listing of all rows and columns in the data. 
	MEANS: Calculates simple summary statistics for  numeric columns in the data.
		   The default statistics are frequncy count, mean, std deviation, min and max.
		   By examining the PROC MEANS results, you can identify average values or values that might be outside of an expected range.
	UNIVARIATE: Generates summary statistics more detailed way.
	FREQ: Creates a frequency table for each column in the input table.
		  The results include the unique values for the column along with their frequency, percent, and cumulative frequency and percent.	  
*/

*by default, proc print lists all columns and rows in the input table;
proc print data=sashelp.class;
run; 

*use to specify the last observation(row) to read;
proc print data=sashelp.class (obs=10); 
run; 

*list the first 10 rows from the sashelp.cars table and displays only the Make, Model, Type, and MSRP columns;
*var is used to select variables that appear in the report and determine their order;
proc print data=sashelp.cars (obs=10);
	var make model type msrp;
run;


*by default, PROC MEANS generates simple summary statistics for each numeric column in the input data;
proc means data=sashelp.cars;
	var enginesize horsepower  mpg_city mpg_highway;
run;

*by default, PROC UNIVARIATE generates summary statistics for each numeric column in the input data;
proc univariate data=sashelp.cars;
	var mpg_highway;
run;


*by default, PROC FREQ creates a frequency table for each column in the input table;
*this PROC FREQ step creates a separate table for Origin, Type, and DriveTrain;
*each table includes a list of the distinct values for the column along with a frequency count, percent, and cumulative frequency and percent;
*this is a great way to validate the data in your columns;
*for example, you might notice unexpected values or values that appear in both uppercase and lowercase;
proc freq data=sashelp.cars;
	tables origin type drivetrain; *use to specify the frequency tables to include in the results;
run; 






