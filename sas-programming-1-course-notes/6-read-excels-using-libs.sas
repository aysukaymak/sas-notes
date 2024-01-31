/*
In addition to SAS data, libraries can be used to access many other types data. 
For example, a library using the XLSX engine can read data directly from Excel spreadsheets. 
Remember that when SAS reads or writes data in a program, it must know where the data is located and what format is it in. 

The only change to the LIBNAME statement syntax is that we specify the "XLSX" engine, and a path that includes the complete Excel workbook file name and extension.
	LIBNAME LIBREF XLSX "path";

You can think of the Excel workbook as a collection of tables. 
Each individual worksheet or named range is one table in the collection. 
When a library is created, all of the worksheets of the xlsx files will be included in the library.

The XLSX engine requires a license for SAS/ACCESS Interface to PC Files, and it also requires SAS 9.4M2 or later.
*/
/*
There are two extra statements that are often used when reading Excel data. 
The first is the OPTIONS statement, a global statement for specifying system options. 
Excel does not have any rules for column headings, so they can be longer than 32 characters and include spaces or other special symbols. 
When SAS reads the Excel data, we can force column names to follow strict SAS naming conventions by using the VALIDVARNAME=V7 system option.
Technically, this enforces the column naming rules established with SAS 7. 
With this option set, SAS replaces any spaces or special symbols in column names with underscores, and names greater than 32 characters are truncated. 
In SAS Studio and Enterprise Guide, the VALIDVARNAME= option is set to ANY by default. 
ANY enables column names to contain special characters, including spaces. 
If a column name contains special characters, the column name must be expressed as a SAS name literal.

The SAS windowing environment sets VALIDVARNAME=V7 by default.
*/
options validvarname=v7;
libname xclass xlsx "/home/u63749159/sasuser.v94/EPG1V2/data/class.xlsx";

proc contents data=xclass.class_birthdate;
run;

libname xclass clear;

/*
When a connection is defined to data sources such as Excel or other databases, it is a good practice to clear, or delete, the libref at the end of the program. 
While the library is active, it might create a lock on the data preventing others from accessing the file, or it could maintain an active connection to the data sources that is unnecessary. 
To clear the library reference, use the LIBNAME statement again, name the libref, and use the keyword CLEAR.
*/