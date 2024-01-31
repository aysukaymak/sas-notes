/*
Formating data is changing how values appear makes it easier to interpret them.
Format just affects displayed data, not raw data values.
You can format several columns using either the same format or different formats in a single FORMAT statement

	proc print data=..;
		format col-name(s) format;
	run
	
	format => <$>format-name<w>.<d>
			 $ indicates a character format
			 w total width of the formatted value
			 . all formats include a period
			 d the number of decimal places for numeric formats
	
	Formats for numeric value
	FormatName ExampleValue FormatApplied FormattedValue
	w.d 	   12345.67 	5. 			  12346
	w.d        12345.67 	8.1 		  12345.7
	COMMAw.d   12345.67 	COMMA8.1      12,345.7
	DOLLARw.d  12345.67 	DOLLAR10.2    $12,345.67
	DOLLARw.d  12345.67 	DOLLAR10.     $12,346
	YENw.d     12345.67 	YEN7.         ¥12,346
	EUROXw.d   12345.67 	EUROX10.2     €12.345,67

International formats just add the symbol to the values. 
The formats do not convert values from one currency to another.

Zw.d writes standard numeric data with leading 0s.
	1350 -> Z8. -> 00001350
	
	
	Formats for date value
	Value Format 	FormattedValue
	21199 DATE7. 	15JAN18
	21199 DATE9. 	15JAN2018
	21199 MMDDYY10. 01/15/2018
	21199 DDMMYY8. 	15/01/18
	21199 MONYY7. 	JAN2018
	21199 MONNAME. 	January
	21199 WEEKDATE. Monday, January 15, 2018
*/

*Format the columns height and weight with the 3. format, which rounds the value to the nearest whole number;
proc print data=pg1.class_birthdate;
	format height weight 3. birthdate date9.;
run;

proc print data=pg1.storm_damage;
	format date MMDDYY10. cost DOLLAR16.;
run;
*when width value is decreased to variable lenght, sas uses scientific notation or missing symbols;

proc freq data=pg1.storm_summary order=freq;
    tables StartDate;
    format startdate monname.; *Formats are an easy way to group data in procedures!;
run;