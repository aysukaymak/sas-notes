/*
So far we have used a hardcoded file path to the SAS table that we want to access, 
and that file path has the two pieces of information that are required for SAS to read the file: 
	where the data is located and  (s:/workshop/data)
	what type of data it is. (/class.sas7bdat)
Because we have been reading a SAS table, providing a path to the data and file name in quotation marks works perfectly. 

-->LIBNAME<---
SAS libraries provide a way to specify the two required pieces of information – the location and file type – in a very simple and efficient way. 
You can think of a library as a collection of data files that are the same type and in the same location. 

A library is created with the LIBNAME statement. 
This is a global statement, and it does not need a RUN statement at the end.

	LIBNAME libref engine "path";

LIBREF: The statement begins with the keyword LIBNAME, followed by what is referred to as a library reference, or libref. 
		The libref is the name of the library. 
		The libref must be eight characters or less, must start with either a letter or underscore, 
		and can include only letters, numbers, and underscores. 
ENGINE: After the libref, specify the engine, which is related to the type of data being accessed. 
		The engine is a behind-the-scenes set of instructions that enables SAS to read structured data files directly, 
		without having to do a separate, manual import into SAS. 
		There are dozens of engines available, including "Base" for SAS tables, Excel, Teradata, Hadoop, and many others. 
		The Base SAS engine is the default, so these two statements are the same.
			libname mylib base "s:/workshop/data";
			libname mylib "s:/workshop/data";
PATH: Finally, provide the location or connection information for the data to be read. 
	  That can be a physical path or directory, or other options to connect to a database.

SAS complies with operating system permissions that are assigned to the data files referenced by the library. 
If you have Write access to the files, you are able to use SAS code to add, modify, or delete data files. 
If you have Read access but do not have Write access, you can read data files via the library, but you cannot make any changes to the files with SAS code.

To prevent SAS from making changes to tables in a library, add "ACCESS=READONLY" at the end of the LIBNAME statement.
	libname mylib base "s:/workshop/data" access=readonly;
	
The path specified must be relative to where SAS is running. 
If SAS is local, you can specify a path to a folder of files on your own machine.
If SAS is on a remote server, the path or folder must be to a location known to the server. 
When the LIBNAME statement is submitted, all the information about the location and file type is associated with the library name, or libref.
*/
/*
After the library is defined, it can be used as a shortcut to access tables in the program. 
To do this, specify the libref, a period, and the table name.
*/
libname mylib base "/home/u63749159/sasuser.v94/EPG1V2/data";
proc contents data=mylib.class_birthdate;
run;

/*
By default, a libref remains active until it is deleted or the SAS session ends. 
Remember that the libref is simply a pointer or shortcut to existing data, so although the libref might be deleted
when SAS shuts down, the data remains in the same place. 
When SAS restarts, re-establish the library and libref by submitting the LIBNAME statement again before accessing the data. 
This is why SAS programs often begin with one or more LIBNAME statements to connect to the various data sources that are used in the code.
*/

libname mylib clear;

