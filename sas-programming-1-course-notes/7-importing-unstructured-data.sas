/*Libraries are an efficient and elegant way to directly access data and use it in a program. 
However, sometimes you need to access unstructured data and to do that, you need to import the file and create a copy as a SAS table.
Let’s start with text files as an example. Text files are simply strings of characters to your computer. 
SAS cannot read text files directly with an engine. We must import the data into a structured format, such as a SAS table, in order to use the data in a program.

PROC IMPORT reads data from an external data source and writes it to a SAS table. 
SAS can import delimited files with any character acting as the delimiter. 
To import a comma-delimited file, use the DATAFILE= option to provide the path and complete file name, 
									  the DBMS= option to define the file type as CSV, and 
									  the OUT= option to provide the library and name of the SAS output table. 
By default, SAS assumes that column names are found in the first row of the file. 

PROC IMPORT DATAFILE="path" DBMS=CSV OUt=output-table-name <REPLACE> <GUESSINGROWS=n|MAX>;
RUN;

The REPLACE option indicates that the SAS output table should be replaced if it already exists. 
By default, SAS scans the first 20 rows of the data to make its best guess for the column attributes, including type and length. 
It is possible that SAS might incorrectly assume a column’s type or length based on the values found in those initial rows. 
Use the GUESSINGROWS= option to provide a set number or use the keyword MAX to examine all rows. 
SAS scans the number of rows that you specify to determine type and length of each column in the imported table.

Here are some common DBMS identifiers that are included with Base SAS:
• CSV – comma-separated values.
• JMP – JMP files, JMP 7 or later.
• TAB – tab-delimited values.
• DLM – delimited files, default delimiter is a space. To use a different delimiter, use the DELIMITER= statement.

Here are additional DBMS identifiers included with SAS/ACCESS Interface to PC Files:
• XLSX – Microsoft Excel 2007, 2010 and later
• ACCESS – Microsoft Access 2000 and later
*/

