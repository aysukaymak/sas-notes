/*
A Sas program consists of a sequence of steps.
Each step in the program performs a specific task.
There are two kinds of steps in Sas:
	DATA step
		Generally readsd data from an input source.
		Processes it, and creates a Sas table.
		Filter rows, compute new columns, join tables and other data manipulations.
	PROC step
		Step proccesses a Sas table in a specific, predefined way.
Most steps end with a RUN statement.
A few PROC steps end with a QUIT statement.

If dont use a RUN statement at the end of a step,
the beginning of a new DATA or PROC step signals the end of the previous step.

Each step consists of a sequence of statements, 
and most statements start with a keyword that is part of the Sas language.

All statements MUST end with a semicolon.

TITLE, OPTIONS, LIBNAME are the global statements. 
These statements can be outside DATA and PROC steps.
Global statements do not need a RUN statement after them.
Commets are also a statements.
*/
data myclass; /*data statement*/
	set sashelp.class; /*set statement*/
	heightcm=height*2; /*assignment statement*/
run; /*run statement*/

proc print data=myclass;
run;

proc means data=myclass;
	var age heightcm;
run;

/*Spacing doesnt matter to Sas, but it does matter for reading.*/
data myclass1; set sashelp.class; run;
proc print data=myclass1; run;

/*
Unqoted values can be typed such as columns, table names, or keywords in any case.
For example; ABC, aBc, abc are okey.
*/
data under13;
	set sashelp.class;
	where AGE<13;
	*comment with * should be end with semicolon;
	*drop heIGht Weight;
run;

/* When code includes mispelled words, sas corrected it temporarily, and executed the statement.*/

