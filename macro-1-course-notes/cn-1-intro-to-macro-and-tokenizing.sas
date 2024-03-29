/*BENEFITS OF USING SAS MACROS
You write macro programs that generate, compile, and execute SAS code.
This enables you to write code that is easy to modify and can even rewrite itself.

With SAS macro, the system values are automatically substituted into the SAS program each time that it executes.
there's no need for you to manually update the code.
easily replace repetitive values, and submit or modify code based on a condition.
generate repetitive SAS code, changing values with each iteration.
build programs dynamically based on data values.

The macro facility processes the text in a program to generate SAS code. 
This code must still be compiled and executed. 
Therefore, the generated code doesn't run faster than your code, but it can reduce your development and maintenance time as a programmer.
*/

*substituting system values;
title1 "Cars List";
title2 "Created at 10:24 AM on October 9, 2019";
footnote "Environment: SAS 9.4 on Win X64_10PRO";
proc print data=sashelp.cars;
run;

*substituting user-defined values;
title "Trucks by Origin";
proc freq data=sashelp.cars;
	where Type="Truck";
	table Origin;
run;

title "Average Highway MPG for Trucks";
proc means data=sashelp.cars mean maxdec=1;
	where Type="Truck";
	var MPG_Highway;
	class Origin;
run;

*conditional processing;
data mpg;
	set sashelp.cars;
	AvgMPG=mean(MPG_Highway, MPG_City);
run;

*repetitive processing;
title "4-Cylinder Cars";
proc print data=sashelp.cars;
	where Cylinders=4;
run;

title "6-Cylinder Cars";
proc print data=sashelp.cars;
	where Cylinders=6;
run;

title "8-Cylinder Cars";
proc print data=sashelp.cars;
	where Cylinders=8;
run;

*data-driven applications;
data hybrid sedan sports suv truck wagon;
	set sashelp.cars;
	select(Type);
		when("Hybrid") output hybrid;
		when("Sedan") output sedan;
		when("Sports") output sports;
		when("SUV") output suv;
		when("Truck") output truck;
		when("Wagon") output wagon;
		otherwise;
	end;
run;

/*SAS PROGRAMMING LANGUAGES
SAS includes several programming languages for accessing and manipulating data, performing analysis, and reporting.
	DATA step language is used for data manipulation, 
	SQL procedure is used for data manipulation and reporting, 
	SAS procedures are used for data analysis and reporting. 
Although their syntax may differ, these languages all share a common concept: you write a program in a text editor and submit it to a compiler. 
The program then compiles and executes. It might read, process, and analyze the data, and it might produce output. 
The output might include data tables, reports, or both.

The SAS macro language is different. 
It accesses and manipulates text to generate SAS program code. 
The code produced by SAS macro is submitted to the compiler on your behalf, as if you had written the program yourself. 
You can think of SAS macro as a language used to generate customized SAS code, or even write entire SAS programs for you.

When you write a program that includes macro code, not all of the code is sent to the compiler. 
The SAS code is sent to the compiler and the macro code is sent to the macro processor. 

When you submit a SAS program, it's copied to an area of memory called the "input stack". 
The presence of the text in the input stack triggers a SAS component called a "word scanner" to begin its work.

The word scanner serves two major functions. 
First, it pulls the raw text from the input stack character by character, left to right, and top to bottom, and transforms it into tokens. 
This process is called "tokenization". 
You can think of a token as the original text with an attached metadata tag to help SAS process it. 
The word scanner sends the tokens to another component for processing. 
*/

/*TOKENS
There are four types of tokens: 
	name tokens, 
	number tokens, 
	literal tokens, 
	special tokens.

Name tokens are a string of up to 32 characters, 
			and they must begin with a letter or an underscore, followed by letters, underscores, and digits. 
This category includes keywords, filenames, and column names. 
Note that the rules for name tokens are the same as for valid SAS names.

Number tokens are numeric values. 
They can include digits, a decimal point, a leading sign, and an exponent (in e/E notation). 
This category also includes SAS date, time, and datetime constants.

Literal tokens are character strings enclosed in single or double quotation marks. 
They can contain any combination of characters up to the maximum length of 32 kilobytes (that is, 32,767 bytes). 
A literal token is treated as a single unit.

A special token is any character that isn't a letter, number, or underscore. 
Special tokens include asterisks, slashes, numeric operators, ampersands, percent signs, and more. (/*+-;().&%)

To build a token, the word scanner reads characters until it reaches a delimiter. 
A delimiter is any whitespace character such as a space, tab, or end of line.

	title "Trucks with Horsepower > 250";
	proc print data=sashelp.cars;
    	var Make Model MSRP Horsepower;
    	where Type="Truck" and Horsepower>250;
	run;

Another way that a token ends is when a new token begins. 
When the word scanner reaches a character that doesn’t meet the rules for the current token, it ends the token that it was building and begins building another. 
In the partial statement Horsepower>250, the greater than symbol isn't valid in a name token, so it signals the end of the name token Horsepower. 
The greater than symbol begins a special token, and it ends at the beginning of the number token 250.
*/

title "Trucks with Horsepower > 250";
proc print data=sashelp.cars;
   	var Make Model MSRP Horsepower;
   	where Type="Truck" and Horsepower>250;
run;

/*TOKENIZATION
1-The word scanner pulls one character at a time until it reaches a delimiter—in this case, a blank.
2-The text "title" is tagged as a name token and passed to the compiler. 
  The next token is a double quotation mark. 
  The word scanner tags it as the start of a literal token, and then reads each of the tokens within the double quotation marks. 
  When it reaches the closing quotation mark, the literal token is passed to the compiler as a single unit. 
3-The semicolon is tagged as a special token and sent to the compiler, ending the TITLE statement. 
4-Then the compiler checks the syntax, and because TITLE is a global statement, it's executed immediately.

When the word scanner sees a quotation mark, it holds all subsequent text in an attempt to build a literal token. 
The literal token ends when the word scanner sees a matching quotation mark. 
If the user forgot to end the literal with a matching quotation mark, the next quotation mark might be the start of another literal token, further down in the code. 
In this case, the resulting literal token might contain SAS statements, and this will likely result in a syntax error when compiled.
*/

/* TOKENIZING CODE WITH MACRO TRIGGERS
Word scanning and tokenization work differently when the program contains macro code, which is identified by macro triggers.
A macro trigger is an ampersand or a percent sign followed immediately by a name token, without an intervening space.
	&name-token --> macro variable
	 %name-token --> macro statement/macro function/macro call

	%PUT text;

The %PUT macro statement writes text to the log. 
Notice that the text is not in quotation marks and that the statement ends with a semicolon, just like a SAS statement. 
You can use %PUT to display custom messages in the log by including NOTE:, WARNING:, or ERROR: in front of the text. 
The message is displayed in the log in the default color for that message type.

So macro triggers modify word scanner behavior, when the word scanner sees a percent sign or an ampersand, it looks at the next token. 
If it’s a name token, the word scanner recognizes the combination as a macro trigger and sends both tokens to the macro processor. 
The compiler is not involved in processing macro code.

The macro processor recognizes the %PUT macro statement and requests more tokens until it receives a semicolon. 
Then the statement executes, writing a custom message to the log in the default color for notes.

There are two areas or tasks involved in processing a macro program: code generation and code processing. 
The submitted code is copied to the input stack, triggering the word scanner to begin tokenization. 
Macro triggers are sent to the macro processor where they are processed or resolved, often involving the use of macro catalogs (where macro programs are stored) and symbol tables (where macro variables are stored). 
The resulting code is copied to the input stack. 
SAS code is sent to the compiler where it's syntax checked and then compiled and executed.
*/

%put NOTE: This is a great program!;
