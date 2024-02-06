/*CONCATENATING TABLES WITH MATCHING COLUMNS
Suppose you have two or more tables that have the same columns, and you need to combine all the rows into a single table. 
We call this concatenating tables.

When the columns have the same names, lengths, and types, then concatenating tables is simple. 
You use the DATA step to create a new table, and list the tables that you want to combine in the SET statement. 
First, SAS reads all of the rows from the first table listed in the SET statement and writes them to the new table, then it reads and writes the rows from the second table, and so on. 
In the same DATA step, you can include any other statements that you need to manipulate the rows read from all tables.

	data output-table;
		set input-table1 input-table2...;
	run;

When multiple tables are listed in a SET statement, as the program is compiled, columns from the first table are added to the PDV with their corresponding attributes. 
When SAS reads the second table in the SET statement, any columns already in the PDV are not changed. 
In other words, the LENGTH is already set and cannot be modified.
If columns with the same name in multiple tables have a different type (character or numeric), the DATA step fails.
*/

data class_current;
	set sashelp.class pg2.class_new;
run;

data storm_complete;
	set pg2.strom_summary pg2.storm_2017(rename=(Year=Season) drop=Location);
run;

*It returns--> WARNING: Multiple lengths were specified for the variable Name by input data set(s). This can cause truncation of data;
data class_current;
	set sashelp.class pg2.class_new2(rename=(Student=Name));
run;

/*MERGE COLUMN ATTRIBUTES
Conflicting column lengths can be solved by using the LENGTH statement. 
Here we are explicitly defining the column Name to be character with a length of 9. 
Notice that the LENGTH statement comes before the SET statement so that it will establish the attributes of Name in the PDV. 
*/

data class_current;
	length Name $9;
	set sashelp.class pg2.class_new2(rename=(Student=Name));
run;

data np_combine;
	set pg2.np_2015 pg2.np_2016;
	CampTotal=sum(of Camping:);
	where Month in (6,7,8);
	format CampTotal comma15.
	drop Camping:;
run;

/*MERGING TABLES
Merging (or joining) tables is a required step when you have columns in multiple tables that need to be combined into a single table. I
A merge, or join, is made by matching values in a common column in the tables. 
There are several scenarios that could arise. 
You could have a one-to-one merge in which each row in one table matches with a single row in the other table. 
You could have a one-to-many merge in which each row from one table matches with one or more rows from the other table. 
And you could also have non-matches in which rows from one table do not have a match in the other table. 
Each of these scenarios can be handled with the DATA step merge.
*/

/*ONE TO ONE MERGING
The DATA step merge process is very similar to how most people envision matching two lists by hand if the values are in sorted order.
SAS simply compares rows sequentially as it reads from the multiple tables, matching rows based on the value of the common column, such as Name or ID. 

	DATA output-table;
		MERGE input-table1 input-table2 ...;
		BY BY-column(s); --->list the common column or columns
	RUN;

The input tables must be sorted by the column (or columns) listed in the BY statement.
In the DATA step, you use a MERGE statement instead of a SET statement. 
You can list multiple tables in the MERGE statement, as long as each table has the common matching column. 
That matching column is then listed in the BY statement. 
Anytime that a BY statement is used in a DATA step, the data must be in sorted order.
Typically, the DATA step is preceded by PROC SORT steps to arrange the rows of the input tables by the matching column. 

The DATA step includes the MERGE statement, listing the sorted tables.
The BY statement identifies Name as the common column in the two tables that will be used to determine matching rows.

Compilation Phase
	1-All the columns from the first table listed in the MERGE statement and their attributes are added to the PDV.
	2-Additional columns from the second table are added to the PDV.
	3-If there are any additional statements in the DATA step that create new variables, they are also added to the PDV, and any other compile-time statements are processed.
Execution Phase
	1-SAS begins by examining the BY column value for the first row in each table. 
	  If they match, then both rows are read into the PDV, additional statements are executed, and at the RUN statement, the row is written to the output table. 
	2-SAS returns to the top of the DATA step for the next iteration, and advances to row 2 in both tables. 
	  Again, Name matches, so both rows are read into the PDV, and so on.
	3-That sequential comparison process continues until all rows are read from each table listed in the MERGE statement.
*/

data class2;
	/*class: name, sex, age, height, weight
	  class_teachers: name, grade, teacher
	  class2: name, sex, age, height, weight, grade, teacher
	*/
	merge sashelp.class pg2.class_teachers;
	by Name;
run;

/*ONE TO MANY MERGING
In the execution phase, SAS reads the first rows in each table, finds a By-value match, and writes values from both tables to the PDV. 
The RUN statement triggers an implicit output and implicit return to the top of the DATA step. 
Because all columns in the PDV are read via the MERGE statement, all values are automatically retained.

For the next row in each table, the BY values do not match, so SAS checks to see whether either BY value matches the current contents of the PDV. 
In this case, Alfred in the test2_sort table matches the current value for Name in the PDV. SAS reads the row from test2_sort and overwrites the previous values for Name, Subject, and TestScore. 
The values for Grade and Teacher from the first table are retained. Again, the RUN statement triggers an implicit output and an implicit return

On the next iteration, neither value for Name matches what is currently in the PDV.
When SAS recognizes that it has completed reading all values for a BY group, the PDV is reinitialized and all columns are set to missing.
Next, the BY values are compared again, and because we have another match, the values from both tables are written to the PDV.
*/

proc sort data=pg2.class_teachers out=teachers_sort;
	by Name;
run;

proc sort data=pg2.class_test2 out=test2_sort;
	by Name;
run;

data class2;
	merge teachers_sort test2_sort;
run;

proc sort data=pg2.storm_summary out=storm_sort;
	by Basin;
run;

proc sort data=pg2.storm_basincodes out=basincodes_sort;
	by BasinCode;
run;

data storm_summary2;
	merge storm_sort basincodes_sort(rename=(BasinCode=Basin));
	by Basin;
run;

/*NONMATCHING ROWS MERGING
When you merge tables together, you might have some rows that do not have a corresponding match in the other table
The new table includes matches and nonmatches.

SAS then compares BY values in the two tables and finds that they do not match, 
so it reads the row from the table with the BY value that comes first in sorted sequence (Carol before David) and writes it to the PDV.
The rest of the columns remain as missing values when the row is written to the new table.

In the next iteration of the DATA step, SAS is still on the row for David in class_update because it has not been read yet. 
SAS compares David to the next unread row in class_teachers, which is Henry. 
Either Dave or Henry would represent a new BY group, so the PDV is reset to missing values. 
Between the two values, David comes first, so the row from class_update is read into the PDV, and the values for Grade and Teacher remain as missing in the PDV.

In class_update, the next unread row is Henry, and there is a match to Henry in class_teachers. 
This pattern of sequential reading of the rows in the input tables based on the BY column values continues until all rows are read from each table.
*/

*like left outer join;
data class2;
	merge pg2.class_update pg2.class_teachers;
	by name;
run;
