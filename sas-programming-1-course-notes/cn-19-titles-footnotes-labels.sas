/*
TITLE<n> "title-text" ;
FOOTNOTE<n> "footnote-text" ;

TITLE is a global statement that establishes a permanent title for all reports created in your SAS session.
The syntax is just the keyword TITLE followed by the title text enclosed in quotation marks.
You can have up to 10 titles. You specify a number 1 through 10 after the keyword TITLE to indicate the line number.
TITLE and TITLE1 are equivalent.
You can also add footnotes to any report with the FOOTNOTE statement.
The same rules for titles apply to footnotes.



*/
title1 "Class Report";
title2 "All Students";
footnote1 "School Use Only";

proc print data=pg1.class_birthdate;
run;

title "Storm Analysis";
title2 "Summary Statistics for MaxWind and MinPressure";

proc means data=pg1.storm_final;
	var MaxWindMPH MinPressure;
run;

title2 "Frequency Report for Basin";

proc freq data=pg1.storm_final;
	tables BasinName;
run;

/*
TITLE;
FOOTNOTE; clears titles and footnotes
ODS NOPROCTITLE; turns off procedure titles

If you want to clear the titles and footnotes that you have specified, you can use the keyword TITLE or FOOTNOTE with no text.
That is called a null TITLE statement.
The null TITLE statement clears all the titles that you have specified on any line.

Some procedures include the name of the procedure in a title above the results.
You can turn this off by submitting an ODS statement with the NOPROCTITLE option.
*/
title;
footnote;
ods noproctitle;

proc means data=sashelp.heart;
	var height weight;
run;

%let age=13;
title1 "Class Report";
title2 "Age=&age";
footnote1 "School Use Only";

proc print data=pg1.class_birthdate;
	where age=&age;
run;

title;
footnote;

/*
Applying Temporary Labels to Columns
LABEL col-name="label-text" ;
*/
proc means data=sashelp.cars;
	where type="Sedan";
	var MSRP MPG_Highway;
	label MSRP="Manufacturer Suggested Retail Price" 
		MPG_Highway="Highway Miles per Gallon";
run;

/*
In PROC PRINT, you must use either the LABEL or SPLIT= option in the PROC PRINT statement to display labels in the report.
When you use the LABEL option, SAS determines whether to split the labels to multiple lines, and if so, where to make the split.
The SPLIT= option enables you to define a character that forces labels to split in specific locations.
*/
proc print data=sashelp.cars label;
	where type="Sedan";
	var Make Model MSRP MPG_Highway MPG_City;
	label MSRP="Manufacturer Suggested Retail Price" 
		MPG_Highway="Highway Miles per Gallon";
run;

proc print data=sashelp.cars split="*";
	var Make Model MSRP MPG_Highway MPG_City;
	label MSRP="Manufacturer Suggested*Retail Price" 
		MPG_Highway="Highway Miles*per Gallon";
run;

/*
When the LABEL statement is used in a DATA step, labels are assigned as permanent attributes in the descriptor portion of the table.
When procedures create reports using that data, labels are automatically displayed.
Notice that the LABEL option is still required in PROC PRINT.
*/

data cars_update;
	set sashelp.cars;
	keep Make Model Type MSRP AvgMPG;
	AvgMPG=mean(MPG_Highway, MPG_City);
	label MSRP="Manufacturer Suggested Retail Price" 
		AvgMPG="Average Miles per Gallon";
run;

proc contents data=cars_update;
run;

proc means data=cars_update min mean max;
    var MSRP Invoice;
run;

proc print data=cars_update label;
    var Make Model MSRP Invoice AvgMPG;
run;

*Most procedures automatically display permanent labels but you must use the LABEL option in PROC PRINT;