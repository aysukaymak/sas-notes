/*
proc sort data=input-table <out=output-table>;
	by <descending> col-name(s);
run;

default is ascending order

First, SAS rearranges the rows in the input table. 
Then SAS creates a table that contains the rearranged rows either by replacing the original table or by creating a new table. 
By default, SAS replaces the original SAS table unless the OUT= option specifies an  output table. 
Keep in mind that PROC SORT does not generate printed output, so you have to open or print the sorted table if you want to look at it. 
Similar to PROC PRINT and other procedures, use the DATA= option to specify the input table.
Next, use the OUT= option in the PROC SORT statement to prevent permanently sorting the input table. 
If you do not include the OUT= option, PROC SORT changes the sort order of the input table.

when use the out option, the resulted table saving in work library temporary.
*/

*ascending order by Name and then within Name by ascending TestScore;
proc sort data=pg1.class_test2 out=test_sort;
	by name testscore;
run;

*ascending order by Subject and then within Subject by descending TestScore;
proc sort data=pg1.class_test2 out=test_sort;
	by subject descending testscore;
run;

proc sort data=pg1.storm_summary out=strom_out;
	where basin in ("NA", "na");
	by descending maxwindmph;
run;
