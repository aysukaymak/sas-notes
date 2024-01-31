/*
AUTOMATIC SAS LIBRARIES

Work and Sashelp are also known as SAS system libraries.

The Work library is a temporary library that is automatically defined by SAS at the beginning of each SAS session. 
We say that the Work library is temporary because any tables written to the Work library are deleted at the end of each SAS session. 
This library is commonly used in SAS programs because it is a great way to create working files that you do not need to save permanently. 
The Work library is also considered to be the default library. If a libref is not provided in front of a table name, 
SAS assumes that the library is Work.
For example, test and work.test both reference the temporary table named test in the Work library.

Another library that SAS automatically defines is the Sashelp library. 
Sashelp contains a collection of sample tables and other files.

If your SAS Platform has an administrator, other automatic libraries might be defined when you open your SAS interface. 
If libraries are defined for you, you do not need to submit a LIBNAME statement. 
You can use the libref that was created by your administrator and the table name to reference data in your program.
*/