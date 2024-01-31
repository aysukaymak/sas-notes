/*
IF expression THEN statement;
*/
data cars2;
	set sashelp.cars;
	if MSRP<30000 then
		Cost_Group=1;
	if MSRP>=30000 then
		Cost_Group=2;
	keep Make Model Type MSRP Cost_Group;
run;

data storm_new;
	set pg1.storm_summary;
	keep Season Name Basin MinPressure PressureGroup;
	if MinPressure=. then
		PressureGroup=.;
	if MinPressure<=920 then
		PressureGroup=1;
	if MinPressure>920 then
		PressureGroup=0;
run;

/*
IF expression THEN statement;
<ELSE IF expression THEN statement;>
<ELSE IF expression THEN statement;>
ELSE statement;
*/
data cars2;
	set sashelp.cars;
	if MSRP<20000 then
		Cost_Group=1;
	else if MSRP<40000 then
		Cost_Group=2;
	else if MSRP<60000 then
		Cost_Group=3;
	else
		Cost_Group=4;
	keep Make Model Type MSRP Cost_Group;
run;

data cars2;
	set sashelp.cars;
	if MSRP<60000 then CarType="Basic";
	else CarType="Luxury";
	keep Make Model MSRP CarType;
run;


data cars2;
	set sashelp.cars;
	if MSRP<60000 then CarType="Basic";
	else CarType="Luxury";
	keep Make Model MSRP CarType;
run;

/*
It is important to know that the first occurrence of a column in the DATA step defines the name, type, and length of the column.
So, if you have an assignment statement that defines a character column and assigns the value Basic, the column is created with a length of 5, the number of characters in the word Basic. 
You can see from the output that Luxury is truncated because it has six characters. 

One way to avoid this problem is to explicitly define a character column in the DATA step with a LENGTH statement. 
The syntax for this statement is the keyword LENGTH followed by the name of the column, a dollar sign to indicate a character column, and the length that you want to assign. 
*/

data cars2;
	set sashelp.cars;
	length CarType $ 6;
	if MSRP<60000 then CarType="Basic";
	else CarType="Luxury";
	keep Make Model MSRP CarType;
run;

data storm_summary2;
    set pg1.storm_summary;
    length Ocean $ 8;
    keep Basin Season Name MaxWindMPH Ocean;
    Basin=upcase(Basin);
    OceanCode=substr(Basin,2,1);
    if OceanCode="I" then Ocean="Indian";
    else if OceanCode="A" then Ocean="Atlantic";
    else Ocean="Pacific";
run;

*compound conditions;
*If you attempt to use AND between two statements, the program fails with a syntax error because you are allowed only one executable statement following THEN. ;
data cars2;
	set sashelp.cars;
	if MPG_City>26 and MPG_Highway>30 then Efficiency=1;
	else if MPG_City>20 and MPG_Highway>25 then Efficiency=2;
	else Efficiency=3;
	keep Make Model MPG_City MPG_Highway Efficiency;
run;

/*
SAS offers alternate syntax that you can use when you want to execute multiple statements for a given condition. 
We call this syntax IF-THEN/DO. After a condition, you type THEN DO and a semicolon. 
After that statement, you can list as many statements as you need to process, and then close the block with an END statement. 
This is repeated for each of the ELSE IF or ELSE DO blocks.

IF expression THEN DO; 
	<executable statements>
END;
ELSE IF expression THEN DO;
	<executable statements>
END;
ELSE DO;
	<executable statements>
END;
*/

data under40 over40;
	set sashelp.cars;
	keep Make Model MSRP Cost_Group;
	if MSRP<20000 then do;
		Cost_Group=1;
		output under40; *output to table
	end;
	else if MSRP<40000 then do;
		Cost_Group=2;
		output under40;
	end;
	else do;
		Cost_Group=3;
	output over40;
	end;
run;

data front rear;
    set sashelp.cars;
    if DriveTrain="Front" then do;
        DriveTrain="FWD";
        output front;
    end;    
    else if DriveTrain='Rear' then do;
        DriveTrain="RWD";
        output rear;
    end;    
run;

*select-when;
data parks monuments;
    set pg1.np_summary;
    where type in ('NM', 'NP');
    Campers=sum(OtherCamping, TentCampers, RVCampers, BackcountryCampers);
    format Campers comma17.;
    length ParkType $ 8;
    select (type);
        when ('NP') do;
            ParkType='Park';
            output parks;
		end;
		otherwise do;
            ParkType='Monument';
            output monuments;
		end;
    end;
    keep Reg ParkName DayVisits OtherLodging Campers ParkType;
run;
 
