/*
A SAS macro variable stores text that is substituted in your code when it runs.
It’s like an automatic find-and-replace.
The SAS macro language enables you to design dynamic programs that are easy to update or modify.
A macro variable enables you to store text and use it in a program.

The first step is to create the macro variable, and we do that with the %LET statement. 
All macro statements begin with a % sign.

The next step is to use the macro variable in the program.
In each place where Wagon is specified, replace it with the macro variable that holds the value CarType. 
To reference a macro variable in a program, precede the name with an ampersand.

Note: It is recommended that you do not include quotation marks when you define the macro variable value.
	  Use quotation marks when necessary after the macro variable is resolved.

The ampersand triggers SAS to look up the text string stored in the CarType macro variable and replace it with Wagon before it executes the code.
Like libraries, macro variables are temporary, so when your SAS session ends, they are deleted. 
If macro variable references are included in a program, the macro variables must be created before they are referenced.
*/

%let CarType=Wagon;

proc print data=sashelp.cars;
	where Type=&cartype;
	var Type Make Model MSRP;
run;

proc means data=sashelp.cars;
	where Type=&cartype;
	var MSRP MPG_Highway;
run;

proc freq data=sashelp.cars;
	where Type=&cartype
	tables Origin Make;
run;


%let windspeed=156;
%let basincode="NA";
%let date="01JAN2000"d;

proc print data=pg1.storm_summary;
	where MaxWindMPH>=&windspeed and Basin=&basincode and StartDate>=&date;
	var Basin Name StartDate EndDate MaxWindMPH;
run;

proc means data=pg1.storm_summary;
	where MaxWindMPH>=&windspeed and Basin=&basincode and StartDate>=&date;
	var MaxWindMPH MinPressure;
run; 

/*
The difference in the WHERE statement in that step is that single quotation marks were used around the macro variable &BasinCode rather than double quotation marks. 
Double quotation marks must be used around macro variables.
*/
%let BasinCode=SP;
proc means data=pg1.storm_summary;
	where Basin="&BasinCode";
	var MaxWindMPH MinPressure;
run;

proc freq data=pg1.storm_summary;
	where Basin="&BasinCode";
	tables Type;
run;
