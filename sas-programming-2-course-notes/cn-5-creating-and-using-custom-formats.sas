/* CREATING CUSTOM FORMATS
In SAS, formats are used to specify how data values are to be displayed.
Remember that when you use a format, the format name contains one period. 
*/

proc print data=pg2.class_birtdate noobs;
	format Height Weight 3.0 Birthdate date9.;
run;

data work.stocks;
    set pg2.stocks;
    CloseOpenDiff=Close-Open;
    HighLowDiff=High-Low;
    format Date MONYY7. Volume COMMA12. CloseOpenDiff HighLowDiff DOLLAR8.2; *DEC2017;
run;

proc print data=stocks (obs=5);
    var Stock Date Volume CloseOpenDiff HighLowDiff;
run;

proc means data=stocks maxdec=0 nonobs mean min max;
    class Stock Date;
    var Open; 
    format Date YEAR4.; *2010;
run;

/*FORMAT PROCEDURE
The FORMAT procedure enables you to create your own custom formats. 
Each VALUE statement specifies the criteria for creating one format.

	proc format;
		value format-name value-or-range-1 = 'formatted-value'
						  value-or-range-2 = 'formatted-value'
						  . . . ;
	run;

FORMAT-NAME= The name can be up to 32 characters in length.
			 Character formats must begin with a $ followed by a letter or underscore. 
			 Numeric formats must begin with a letter or underscore.
			 The name cannot end in a number or match an existing SAS format.

VALUE-OR-RANGE= You specify individual values or a range of values that you want to convert to formatted values. 
				Character values need to be in quotation marks. Numeric values do not.

FORMATTED-VALUE= You specify the formatted values that you want the values on the left side to become. 
				 Formatted values are enclosed in quotation marks.

You can define more than one custom format at a time by using multiple VALUE statements in a PROC FORMAT step.

This PROC FORMAT step creates a character format called $REGFMT. 
There is no period after the name of the format name in the VALUE statement. 
The format definition specifies that a character value of a capital C should be formatted as Complete and a character value of a capital I should be formatted as Incomplete. 
Notice that there is no reference to a data table or a specific column in the PROC FORMAT step.
 This format can be applied to any column that contains those values in any table.
This PROC PRINT step applies $REGFMT to the Registration column in the class_birthdate table. 
There is a period after the name of the format when you use it.

Range 		Starting Value 		Ending Value
58–60 		Includes 58 		Includes 60
58–<60 		Includes 58 		Excludes 60
58<–60 		Excludes 58 		Includes 60
58<–<60 	Excludes 58 		Excludes 60

Keywords can be specified in the VALUE statement to enhance your selection.
	• You can use LOW or HIGH as one value in a range. 
	  The LOW keyword includes missing values for character variables and does not include missing values for numeric variables.
	• You can use the keyword OTHER as a single value. 
	  OTHER matches all values that do not match any other value or range.
*/

proc format;
	value $regfmt 'C'='Complete'
				  'I'='Incomplete'
			    other= 'Miscoded';
	value hrange low-<58='Below Average'
				 58-60='Average'
				 60-high='Above Average';
run;

proc print data=pg2.class_birthdate noobs;
	var Name Registration Height;
	format Registration $regfmt. Height hrange.;
	where Age=12;
run;

proc format;
    value stdate low - '31DEC1999'd = '1999 and before'
                 '01JAN2000'd - '31DEC2009'd = '2000 to 2009'
                 '01JAN2010'd - high = '2010 and later'
                 . = 'Not Supplied';
    value $region 'NA'='Atlantic'
				  'WP', 'EP', 'SP'='Pacific'
				  'NI', 'SI'='Indian'
				  ' '='Missing'
				  other='Unknown';	
run;

proc freq data=pg2.storm_summary;
	tables Basin*StartDate / norow nocol;
	format StartDate stdate. Basin $region.;
run;

*to creating formatted new columns;
data storm_summary;
    set pg2.storm_summary;
    Basin=upcase(Basin);
    BasinGroup=put(Basin, $region.); 
run;

proc means data=storm_summary maxdec=1;
	class BasinGroup;
	var MaxWindMPH MinPressure;
run;

proc format;
	value $highreg 'IM'='Intermountain'
				   'PW'='Pacific West'
				   'SE'='Southeast'
				   other='All Other Regions';
run;

title 'High Frequency Regions';
proc freq data=pg2.np_summary order=freq;
    tables Reg;
    label Reg='Region';
	format reg $highreg.;
run;
title;

proc format;
	value psize low-<10000='Small'
		  10000-<500000='Average'
		  500000-high='Large'
run;

data np_parksize;
    set pg2.np_acres;
	parkSize=put(GrossAcres, psize.);
    format GrossAcres comma16.;
run;

*Nesting Formats;
proc fortmat;
	value decade '01Jan2000'd-'31Dec2009'd = '2000-2009'
                 '01Jan2010'd-'31Dec2017'd = '2010-2017'
                 '01Jan2018'd-'31Mar2018'd = '1st Quarter 2018'
                 '01Apr2018'd-high = [mmddyy10.];
run;

proc means data=pg2.np_weather maxdec=2 sum mean nonobs;
	var Prcp Snow;
	class Date Name;
	format Date decade.;
	where Prcp>0 or Snow>0;
run;

/*CREATING CUSTOM FORMATS FROM TABLES
If the data is stored in a table, you can read the values from the table to create the format. 

When you use an input table to create a format, the table must have a particular structure with at least three specific character columns. 
	• FmtName contains the name of the format that you are creating. 
	  Remember that character formats begin with a dollar sign.
	• Start contains the values to the left of the equal sign in the VALUE statement (the values that you want to format). 
	• Label contains the values to the right of the equal sign in the VALUE statement (the labels that you want to apply to the values). 
You might need additional columns depending on the requirements of the format. 
For example, if you are specifying ranges, you need an End column in addition to a Start column. 
More than likely, your input table will not have the appropriately named columns. 
Using a DATA step, you can create a new version of the data that you can use for creating a format. 

To build the table to generate the format, the RETAIN statement creates the FmtName column and retains the value $sbfmt for each row. 
The SET statement reads the input table and renames the Sub_Basin and SubBasin_Name columns. 
In the end, our new table, work.sbdata, will have the three columns (FmtName, Start, and Label) with a row for each SubBasin value.

It is very simple to read a table to create a custom format when the table has the correct layout. 
Simply use the CNTLIN= option in the PROC FORMAT statement to name the input table. 
The VALUE statement is no longer needed.
*/

data sbdata;
	retain FmtName '$sbfmt';
	set pg2.storm_subbasincodes(rename=(Sub_Basin=Start SubBasin_Name=Label));
	keep Start Label FmtName;
run;

proc format cntlin=sbdata;
run;

/*Complete the steps to create the CATFMT format from the storm_categories table*/
data catdata;
    retain FmtName 'catdata';
    set pg2.storm_categories(rename=(Low=Start
									 High=End
									 Category=Label));
    keep FmtName Start End Label;
run;

proc format cntlin=catdata;
run;

title "Frequency of Wind Measurements for Storm Categories by SubBasin";
title2 "2016 Storms";
proc freq data=pg2.storm_detail;
    /*include only Category 1-5 2016 storms with known subbasin*/
	where Wind>=64 and Season=2016 and Sub_basin not in('MM', 'NA');
	tables Sub_basin*Wind / nocol norow nopercent;
	format Sub_Basin $sbfmt. Wind
run;
title;

data np_lookup;
	retain FmtName '$RegLbl';
	set pg2.np_codeLookup(rename=(ParkCode=Start));
	if Region ne ' ' then Label=Region;
	else Label='Unknown';
	keep Start Label FmtName;
run;

proc format cntlin=np_lookup;
run;

data np_endanger;
	set pg2.np_species;
	where Conservation_Status='Endangered';
	Region=put(ParkCode, $RegLbl.);
run;

*Use the CNTLOUT= option to create a table named typfmtout from the existing $TypCode format;
proc format cntlout=typfmtout;
    select $TypCode;
run;

*Create a table named typfmt_update by concatenating the output table from PROC FORMAT and the pg2.np_newcodes table;
data typfmt_update;
	set typfmtout pg2.np_newcodes;
	keep FmtName Start Label;
	FmtName='$TypCode';
run;

proc format cntlin==typefmt_update;
run;

/*Generated a report for all formats in the WORK library is generated.*/
proc format fmtlib library=work;
run;

proc format fmtlib library=work;
	select $sbfmt catfmt;
run;

/*LOCATION OF CUSTOM FORMATS
By default, custom formats are stored in the temporary Work library in a catalog named formats.

If you want to store your formats in a different location other than WORK.FORMATS, you can use the LIBRARY= option. 
This option can be shortened to LIB=. 
You can specify the library and a catalog name, such as PG2.MYFMTS. 
If you specify only the library, the default catalog formats is used.

proc format library pg2.myfmts;
proc format library=pg2;
proc format lib=pg2;
*/

proc format cntlin=catdata library=pg2.myfmts;
run;

/*SEARCHING FOR CUSTOM FORMATS
When SAS encounters a format, it has to look up the format definition. 
By default, SAS searches for formats in the formats catalog of the Work library and, if there is a library named Library, it also searches in the formats catalog there. 
If you save your custom formats to another location, you must tell SAS where to find them.
In the global OPTIONS statement, you use the FMTSEARCH= option to specify additional locations to search. 
This OPTIONS statement directs SAS to search in the myfmts catalog of the Pg2 library and the formats catalog of the Sashelp library after it searches the default locations WORK.FORMATS and LIBRARY.FORMATS.
*/
options fmtsearch=(pg2.myfmts sashelp);

proc format library=pg2.formats ;
    value $reg 'C' = 'Complete'
               'I' = 'Incomplete'                             
             other = 'Miscoded';
    value hght low-<58  = 'Below Average'
                58-60   = 'Average'
               60<-high = 'Above Average';
run;

options fmtsearch=(pg2.formats);

proc print data=pg2.class_birthdate noobs;
    where Age=12;
    var Name Registration Height;
    format Registration $reg. Height hght.;
run;

