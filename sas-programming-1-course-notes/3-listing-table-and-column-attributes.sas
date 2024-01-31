/*
PROC CONTENT statements is used to view table attributes.
The CONTENT procedure creates a report of the descriptor portion of the table.
*/

proc contents data="/home/u63749159/sasuser.v94/EPG1V2/data/storm_summary.sas7bdat";
run;

/*
The path provided in the program must be relative to where SAS is running. 
If SAS is on a remote server, the path points to the server, not the local machine.
The output of PROC CONTENTS is a listing of the information in the descriptor portion of the table. 
You can also think of this as the metadata or properties of the table. 
The first two sections of the report give general information about the table, including where the table is stored, when it was 
created and modified, and the number of rows and columns. The variable list provides the column names along with their type and length.
*/