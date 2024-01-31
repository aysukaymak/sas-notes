/*
The XLSX library engine can read and write Excel data directly, but you might prefer to import a copy of your Excel data as a SAS table and use that SAS table in your program. 
If SAS/ACCESS to PC Files is licensed, PROC IMPORT can accomplish this. 
Change the DATAFILE= value and the DBMS option to reference XLSX and use the SHEET= option to tell SAS which worksheet you want to read. 
PROC IMPORT can read only one spreadsheet at a time, and by default it reads the first worksheet.

Note: If the Excel file is open when PROC IMPORT runs, an error occurs.

PROC IMPORT DATAFILE="path/file-name.xlsx" DBMS=XLSX OUT=output-table <REPLACE>;
	SHEET=sheet-name;
RUN;
*/

proc import datafile="/home/u63749159/sasuser.v94/EPG1V2/data/class.xlsx"
			dbms=xlsx
			out=work.class_test_import replace;
	sheet=class_test;
run;

/*
The xlsx libname engine reads data directly from the excel file, so programs that referene the excel library will always use the current data.
Proc imports creates a copy of the excel file that is a snapshot in time until the import steos runs again.
*/