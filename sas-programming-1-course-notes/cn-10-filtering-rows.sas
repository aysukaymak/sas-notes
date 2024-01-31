/*
WHERE statement is used to subset your data. 
The WHERE statement can be used in PROC PRINT, MEANS, FREQ, UNIVARIATE and many others.

proc ....;
	where expression;
run; 

If expression is true, include the row in the results.

The WHERE statement consists of the keyword WHERE followed by one or more expressions. 
An  expression tests the value of a column against a condition. 
The expression evaluates as true or false for each row.
Note: Either the symbol or letters can be used to represent these operators in an expression. 

	where column operator value;
		= or EQ
		^= or ~= or NE
		> or GT
		< or LT
		>= or GE
		<= or LE

In an expression; Character values are case sensitive and must be enclosed in double or single quotation marks.
				  Numeric values must be standard numeric (that is, no symbols or quotations).
				  Dates are stored as numeric values, so the expression is evaluated based on a numeric comparison. 
				  If you want to compare a date column to a fixed date, then you can use the SAS date constant notation. 
				  SAS turns the string date into the numeric equivalent in order to evaluate the expression.
						"ddmmmyyyy"d
						where date > "01JAN2015"d;
						where date > "1jan15"d;
	
Expressions can be combined with AND or OR, IN
	where type="SUV" and msrp<=30000;
	where type in ("SUV","Truck","Wagon");
	where type not in ("SUV","Truck","Wagon");
The IN operator works with both numeric and character values. 
Remember that character values are case sensitive and must be enclosed in quotation marks. 
The keyword NOT can be used to reverse the logic of the IN operator. 
*/

proc print data=pg1.storm_summary;
	*where maxwindmph >= 156;
	*where basin = "WP";
	*where basin in ("SI", "NI");
	*where startdate >"01jan2010"d;
	*where type="TS" and hem_ew="W";
	*where maxwindmph >= 156 or minpressure<920;
	where 0<minpressure<920;
run;

/*

IS MISSING and IS NOT MISSING operators work for both character and numeric missing values.
	where age is missing;  
	where name is not missing;
	
	or 

	where age=.;
	where name=" ";	
IS NULL is another special operator that can be used with DBMS data. It distinguishes between null and missing values.
IS NULL and IS MISSING are the same when they are used with a SAS table.
	where item is null;

BETWEEN AND includes rows with values between and including the endpoints that you specify.
For character values, the range is based on the alphabet.
	where age between 20  and 39;

LIKE checks the same values.
	where city like "New%"; % is wildcard for any numbers of characters
	where city like "Sant_ %" is wildcard for a single characters
*/

proc print data=pg1.storm_summary(obs=50);
	*where MinPressure is missing; /*same as MinPressure = .*/
	*where Type is not missing; /*same as Type ne " "*/
	*where MaxWindMPH between 150 and 155;
	*where Basin like "_I";
	where stroms like "Z%"
run;
