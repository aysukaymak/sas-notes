/* From 1-program-syntax.sas — basic DATA + PROC steps from the SAS Programming 1 notes */

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

data under13;
	set sashelp.class;
	where AGE<13;
run;
