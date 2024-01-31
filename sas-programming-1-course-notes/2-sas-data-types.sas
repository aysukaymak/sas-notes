/*
Structured data: SAS has engines to enable it to understand and read various types of structured data.
				 Includes defined rows and columns
				 SAS, Oracle, Teradata, Microsoft Excel, Hadoop, Versa tables, and others
Unstuctured data: Unstructured data must be imported into SAS before you can analyze or report on it. 
				  Includes data, but not defined columns
				  Text, delimited, JSON, weblogs, and other files
Sas tables: A SAS table is a structured data file that has defined columns and rows. 
			SAS tables have the file extension ".sas7bdat".
			There are two parts to a SAS table: a descriptor portion and a data portion. 
			The descriptor portion contains information about the attributes of the table, or metadata. 
			The metadata includes general properties such as the table name, the number of rows, and the date and time that the table was created.
			The descriptor portion also includes the column definitions such as column names and attributes.
			The data portion of a SAS table contains the data values, stored in columns. 
row or observation, column or variable, table or dataset			
*/
/*
In SAS, all columns must have a name, type, and length attributes.
	Name: 1 – 32 characters
		  Starts with a letter or underscore. Continues with letters, numbers, or underscores. (Sas allow special characters comes from other platforms tables.)
		  Can be uppercase, lowercase, or mixed case
		  Column names are stored in the case that you use when you create the column, and that is the way the column name appears in reports. 
		  After a column has been created, it can be typed in any case in your code without affecting the way that it is stored.
		  Depending on the environment used to submit your SAS code, SAS might allow for spaces and special symbols other than underscores in column and table names. 
		  If you use data sources other than SAS that have flexible column-name rules, SAS can make allowances for that. 
	Type: Numeric can be digits(0 – 9), minus sign, decimal point, scientific notation (E).
		  Character can be letters, numbers, special characters, blanks.
		  SAS date values represent the number of days between January 1, 1960, and a specified date. 
		  SAS can perform calculations on dates ranging from A.D. 1582 to A.D. 19,900.
          SAS time values represent the number of seconds since midnight of the current day.
		  SAS datetime values represent the number of seconds between midnight on January 1, 1960, and an hour/minute/second within a specified date.
		  Before 1jan 1960, number of days will display with negative sign.
	Length: The column length is the number of bytes allocated to store column values. 
			The length is related to the column type.
			Numeric columns, by default, are always stored as 8 bytes, which is enough for about 16 significant digits. 
			Character columns can be any length between 1 and 32,767 bytes, and a byte stores one character.
			SAS uses floating-point representation to store numeric values. 
			Floating-point representation supports a wide range of values (very large or very small numbers) with an adequate amount of numerical accuracy.
			
A blank is stored for a character missing value and a period(dot) is stored for a numeric missing value.
*/

