/*
The DATA step is a powerful tool to create, clean, and prepare your data!
	filter rows and columns
	compute new columns
	conditionally process

data output-table;  
	set input-table;
run;

When you work with data, you want to preserve your existing data and create a copy that you can work on, so let’s start with a simple DATA step that does just that. 
	• The DATA statement names the table that you want to create, or the output table. 
	This can be a temporary table if you use the Work library or a permanent table if you use any other library. 
	Be aware that if the table you list in the DATA statement exists and you have Write access to it, the DATA step overwrites that table.
	• The SET statement names the existing table that you are reading from, or the input table. 
	When I reference a data source as libref.table, then based on a previous LIBNAME statement, SAS knows where to find the data source and how to read it. 
	• The DATA step ends with a RUN statement.

*/

*creates the table myclass in the Work library and reads the table class in the Sashelp library;
data myclass;
	set sashelp.class;
run;

/*
The DATA step has two phases: compilation and execution.
In the compilation phase, SAS checks for syntax errors in the program and establishes the table metadata, such as column name, type, and length.
In the execution phase, the data is read, processed, and written one row at time. 

DATA step execution is like an automatic loop. 
The first time through the DATA step, the SET statement reads the first row from the input table and then processes any other statements in sequence, manipulating the values within that row. 
When SAS reaches the RUN statement, there is an implied OUPUT action, and the new row is written to the output table. 
The DATA step then automatically loops back to the top and executes the statements in order again, this time reading, manipulating, and outputting the second row. 
That implicit loop continues until all rows are read from the input table.
	Execution
		1) Read a row from the input table.
		2) Sequentially process statements. 
		3) At the end, write the row to the output table.
		4) Loop back to the top of the DATA step to read the next row from the input table
*/


/*
The same WHERE syntax that works in a procedure to subset data for a report or analysis works in the DATA step to filter rows. 
Only those rows from the input table that meet the criteria in the WHERE statement are processed by the DATA step and written to the output table 

To specify the columns to include in the output data, use either the DROP statement or the KEEP statement followed by the column names from the input table to drop or keep.
	DROP col-name <col-name>; remove
	KEEP col-name <col-name>; keep
*/

data classkd;
	set sashelp.class;
	where age >=15;
	*keep name age height;
	drop sex weight;
run;

/*
The FORMAT statement is used in procedures to change how data values are displayed in a report or analysis. 
We can use the same FORMAT statement in the DATA step, but the impact is a little different. 
A FORMAT statement in the DATA step permanently assigns a format to a column in the properties of the new table. 
The raw data values are still stored in the table, but anytime you view the data or use it in procedures, the formats are automatically applied.
*/

data classformat;
	set sashelp.class;
	format height 4.1 weight 3.;
run;

libname out "/home/u63749159/sasuser.v94/EPG1V2/output";

data out.storm_cat5;
	set pg1.storm_summary;
	where StartDate>="01jan2000"d and MaxWindMPH>=156; 
    keep Season Basin Name Type MaxWindMPH; 
run;


data fox;
    set pg1.np_species;
    where Category='Mammal' and upcase(Common_Names) like '%FOX%' 
        and upcase(Common_Names) not like '%SQUIRREL%';    
    drop Category Record_Status Occurrence Nativeness;
run;

proc sort data=fox;
    by Common_Names;
run;
