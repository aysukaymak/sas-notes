data storm_complete; 
	set pg2.storm_summary_small;
	putlog "PDV after SET statement:";
	putlog _all_;
	length ocean $ 8;
	drop EndDate; *deleting the enddate column is not  affect the stormlength calculation. The enddate column just not displaying the output table;
	where Name is not missing;
	Basin=upcase(Basin);
	StormLength=EndDate-StartDate;

	if substr(Basin, 2, 1)="I" then
		Ocean="Indian";
	else if substr(Basin, 2, 1)="A" then
		Ocean="Atlantic";
	else
		Ocean="Pacific";
run;

/* DATA STEP PROCESSING

When you run a DATA step, it goes through two phases: compilation and execution.
	In the compilation phase, SAS prepares the code and establishes data attributes and the rules for execution.
		1) Check for syntax errors.
		2) Create the program data vector (PDV), which includes all columns and attributes.
		3) Establish the specifications for processing data in the PDV during execution.
		4) Create the descriptor portion of the output table.
	In the execution phase, SAS follows those rules to read, manipulate, and write data.
		1) Initialize the PDV.
		2) Read a row from the input table into the PDV.
		3) Sequentially process statements and update values in the PDV. 
		4) At the end of the step, write the contents of the PDV to the output table.
		5) Return to the top of the DATA step.

In the compilation phase, SAS runs through the program to check for syntax errors.
If there are no errors, SAS builds a critical area of memory called the "program data vector", or "PDV" for short.
The PDV includes each column referenced in the DATA step and its attributes, including the column name, type, and length.
The PDV is used in the execution phase to hold and manipulate one row of data at a time.
Also in the compilation phase, SAS establishes rules for the PDV based on the code, such as which columns will be dropped, or which rows from the input table will be read into the PDV.
Finally, SAS creates the descriptor portion, or the table metadata.

When the compilation phase is complete, the program is ready for action in the execution phase. In this phase, SAS reads data, processes it in the PDV, and outputs it to a new table.
DATA step execution acts like an automatic loop. 
The first time through the DATA step, the SET statement reads the first row from the input table, and then processes any other statements in sequence, manipulating the values in the PDV. 
When SAS reaches the end of the DATA step, there is an implied OUPUT action so that the contents of the PDV, minus any columns flagged for dropping, are written as the first row in the output table. 
The DATA step then automatically loops back to the top and executes the statements in order again, this time reading, manipulating and outputting the next row. 
That implicit loop continues until all of the rows are read from the input table. 
Compile-time statements such as DROP, LENGTH, and WHERE are not executed for each row. 
However, because of the rules that they established in the compilation phase, their impact will be observed in the output table.
*/

/*	COMPILATION PHASE

To build the PDV, SAS passes through the DATA step sequentially, adding columns and their attributes.
The SET statement in this program is listed first, so all of the columns from the storm_summary_small table are added to the PDV along with the required column attributes name, type, and length.
Optional attributes such as formats or labels might also be included for columns that have them.

Any other statements that define new columns will add to the PDV.
The LENGTH statement is next after SET, and it explicitly defines the character column Ocean with a length of 8.
StormLength is the last new column, and, based on the arithmetic expression, it is defined as a numeric column with a default length of 8.

There are certain statements that are specific to the compilation phase and establish the behavior of the PDV.
The DROP statement does not remove a column from the PDV. Instead, SAS marks the column with a drop flag so that it is dropped later in execution.
In this program, EndDate will eventually be dropped from the output data, but it is still be available to use in the PDV for calculating the column StormLength.
So, DROP or KEEP statements flag columns that will e excluded from the output table.

The WHERE statement defines which rows are read from the input table into the PDV during execution.  Just like flags, it is specified the rules or conditions.

Finally, the descriptor portion of the output table is completed. Notice that the EndDate column is not included in the descriptor portion of the output table.

KEEP DROP WHERE LENGTH are the compiletime statements
SET is not compile time statement.
*/

/* VIEWING EXECUTION IN THE LOG

For writing all columns and values in the PDV to the log.
	putlog _all_;

For writing seleted columns and values in the PDV to the log.
	putlog column=, (putlog name=;)

For writing a text string to the log.
	putlog "message"; 

For adding prefix color-codes the text as a note in the log.
	putlog "NOTE: message";

The DATA step debugger in SAS Enterprise Guide works only with DATA steps.
*/