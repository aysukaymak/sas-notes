/*PERFORMING PATTERN MATCHING WITH PERL REGULAR EXPRESSIONS
A regular expression is a sequence of characters that defines a search pattern. 
	/([2-9]\d\d)-([2-9]\d\d)-(\d{4})/
			234-567-8901
			1-345-678-9012
			901-234-5678 US
This regular expression defines a pattern for US and Canada phone numbers. 
We can use it to validate values in the Phone column.

Although they are often cryptic, Perl regular expressions are very powerful. 
You can often accomplish in a single Perl regular expression something that would require a combination of traditional SAS functions.

The names of the Perl regular expression functions and CALL routines begin with the letters PRX for Perl Regular Expressions. 
They're in the Character String Matching category. 
You use them to parse character strings, 
				perform data validation, 
				standardize data through text substitution, 
				and extract multiple matching patterns from a string in a single step.

Recall that a function returns a value whereas a CALL routine can modify the value of variables and doesn't return a value.
*/
/*METACHARACTERS
Before you can use the PRX functions, you need to write the regular expression (or regex) to use for pattern matching. 
A regex is made up of characters to be matched exactly and special characters called metacharacters, all enclosed in a set of delimiters. 
Paired forward slashes are the default delimiters.
	/([2-9]\d\d)-([2-9]\d\d)-(\d{4})/
		// are the default delimiters
		([2-9]\d\d) is a set of three digits
		- is a hyphen
		(\d{4}) is a set of four digits

		234-567-8901
		1-345-678-9012
		901-234-5678 US
	
You might be surprised to see that that one match includes a 1- prefix, and another is followed by US.
Keep in mind that the Phone values contain substrings that match the pattern, and our regular expression didnt specify that we were looking for only an exact match.

	Metacharacter 	Behavior 
		/…/ 		Forward slash is starting and ending delimiter.
		(…) 		Parentheses are for grouping.
		| 			Vertical line is for OR situation.
		\d 			Matches a digit (0-9).
		\D 			Matches a non-digit such as letter or special character.
		\s 			Matches a whitespace character such as space or tab.
		\w 			Matches a word character (a-z, A-Z, 0-9, or underscore).
		\W			Matches a non-word character.
		\b			Matches a word boundary.
		\B			Matches a non-word boundary (most special characters).
		. 			Matches any character (letter, digit, or underscore).
		[…] 		Matches a character in the brackets.
		[^…] 		Matches a character not in the brackets.
		^ 			Matches the beginning of the string.
		$ 			Matches the end of the string.
		* 			Matches the preceding character 0 or more times.
		+ 			Matches the preceding character 1 or more times.
		? 			Matches the preceding character 0 or 1 times.
		{n} 		Matches exactly n times.
		\ 			Escape character, overrides the next metacharacter such as a ( or ?. 
		\n 			Matches the n capture buffer.

Notice that the \D matches any non-digit character. 
Likewise, backslash \w matches a word character, and backslash uppercase \W matches a non-word character. 
Word characters are defined as uppercase and lowercase letters, the digits 0 through 9, and the underscore. 
\b matches a word boundary, and \B matches a non-word boundary.

A dot matches any single character. 
You use [] to match a single character in a set. 
And you include the caret symbol ^ before the set to match any character that is not in the set.

Perl regular expressions sometimes use the same character for different purposes, and the caret is one such character.
Recall that in our example a match was reported even if the value of Phone had other characters before or after it.
We can define a match more tightly by specifying a caret at the beginning of the pattern and a $ at the end. 
Now the pattern requires that the match must start at the beginning of the input string and end at the end of the input string. 
In other words, there can't be any other characters before or after the matching characters.
	/^([2-9]\d\d)-([2-9]\d\d)-(\d{4})$/

There are many other metacharacters that you can use to specify the number of characters and the number of matches. 
For example, the asterisk matches the preceding character zero or more times, the plus matches the preceding character one or more times, and the question mark matches the preceding character zero times or one time. 
This is useful when a particular character is optional. 
You can specify an exact number of matches in braces.

What if you need to match a plus sign or an asterisk? 
They are both metacharacters, but you can place a backslash in front of the character to match it literally. 
The backslash is called an escape character because it escapes or hides the special meaning of that character.

Examples of metacharacters:
	|		dog|cat|fox matches “dog” or “cat” or “fox”
			d|fog matches “dog” or “fog”
	\d 		\d\d\d\d matches any four-digits (0-9) such as “0123” or “6387”
	\D 		\D\D\D\D matches any four non-digits such as “WxYz” or “AVG%”
	\s		\sBob\s matches “ Bob “ 
			\D\D\D\D\s\d matches “Apt# 5”
	\w 		\w\w\w\w\w\w\w matches any seven-word characters such as “F_Last2”
	.		mi.e matches “mike” or “mice”
			..i.e matches “white” or “smile”
	[…]		[dmn]ice matches “dice” or “mice” or “nice”
			\d[6789]\d matches “162” or “574” or “685” or “999”
	[^…]	[^mn]ice matches “dice” but not “mice” or “nice”
			\d[^6789]\d matches “152“ or “608” but not “574“ or “999”
	^ 		^ter matches “terrific” but not “test”
	$ 		ter$ matches “winter” but not “winner”
	\b 		Corp\b matches “Corp.” or “Corp XYZ” but not “Corporation” or “Corp123” or “Corp_A”
	\B 		Corp\B matches “Corporation” or ”Corp123” or “Corp_A” but not “Corp.” or “Corp XYZ”
	* 		dog* (g can appear 0 or more times) matches “do” or “dog” or “doggg”
	+ 		dog+ (g can appear 1 or more times) matches “dog” or “doggg” but not “do”
	? 		dog? (g can appear 0 or 1 times) matches “do” or “dog”
	{n}		\w{7} matches any seven-word characters such as “F_Last2”
			dog{3} matches the letters “do” plus letter “g” three times such as “doggg”
			(dog){3} matches the letters “dog” three times such as “dogdogdog”
	\ 		\(\d+\) matches a value with a “(“, one or more digits, and a “)” such as “(123)”
	\n 		(\dA\d)\1 matches “1A21A2” (first grouping is repeated) but not “1A23A4” 
			(B\dB)(\dA\d)\1 matches “B9B1A2B9B” (first grouping is repeated)
			(B\dB)(\dA\d)\2 matches “B9B1A21A2” (second grouping is repeated)
*/

/*PRXPARSE FUNCTION
The PRXPARSE function compiles a Perl regular expression and returns a pattern identifier number that is used by other Perl functions and CALL routines to match patterns. 
If an error occurs in parsing the regular expression, SAS returns a missing value.
	
	pattern-id=PRXPARSE(perl-regex);

If the argument is a constant, the regular expression is compiled only once. 
Successive calls to PRXPARSE return the pattern ID for the compiled regular expression. 
The ID is sometimes called a regular expression ID.
	pid=prxparse('/([2-9]\d\d)-([2-9]\d\d)-(\d{4})/');

An alternative is to use the /O option to specify one-time-only compilation of the regular expression.
Either method simplifies your code because you don't need to use an initialization block, testing whether _N_ is equal to 1, to control the number of compilations.
	exp='/([2-9]\d\d)-([2-9]\d\d)-(\d{4})/o';
	pid=prxparse(exp); 		
After the regular expression is compiled, you can use a pattern ID as an argument to other functions, including PRXMATCH.

The PRXMATCH function is commonly used for validating data.
It searches a source string for a pattern match and returns the position at which the matching text begins, or zero if no match is found. 
This function has two arguments: the Perl regular expression that defines the pattern, and the source to be searched. 
The first argument to PRXMATCH specifies the pattern and can be a pattern ID,
															 a constant, 
															 or a column.
The value of source can be a character constant,
							 column,
							 or expression.

	loc=PRXMATCH(perl-regex, source);

	exp='/([2-9]\d\d)-([2-9]\d\d)-(\d{4})/o';
	pid=prxparse(exp); 
	loc=prxmatch(pid, phone);   

	or 

	loc=prxmatch('/([2-9]\d\d)-([2-9]\d\d)-(\d{4})/o', phone)

	or  

	exp='/([2-9]\d\d)-([2-9]\d\d)-(\d{4})/o';
	loc=prxmatch(pid, phone);   

Notice that the value of Exp and the value of Pid are the same for every iteration.
If we didn't use the O option at the end of the Perl regular expression, the value of Pid would differ for each row.

We can also use a hardcoded constant enclosed in single or double quotation marks as the first argument. 
With this method, the expression is compiled once, and the compiled version is saved in memory. 
Each time PRXMATCH is called in this program, the compiled expression is used.
*/

*constant;
data ValidPhoneNumbers;
	set pg3.phonenumbers_us;
	loc=prxmatch('/([2-9]\d\d)-([2-9]\d\d)-(\d{4})/o', phone);
run;

*column;
data ValidPhoneNumbers;
	set pg3.phonenumbers_us;
	exp='/([2-9]\d\d)-([2-9]\d\d)-(\d{4})/o';
	loc=prxmatch(pid, phone);   
run;

*pattern id number;
data ValidPhoneNumbers;
	set pg3.phonenumbers_us;
	exp='/([2-9]\d\d)-([2-9]\d\d)-(\d{4})/o';
	pid=prxparse(exp); 
	loc=prxmatch(pid, phone);   
run;

title 'Category EF3 and EF4 Tornados';
proc print data=pg3.tornado_2017narrative;
    where prxmatch('/(EF3|EF-3|EF4|EF-4)/',Narrative)>0; 
    *where prxmatch('/(EF-?3|EF-?4)/',Narrative)>0; 
    *where prxmatch('/EF-?(3|4)/',Narrative)>0; 
    *where prxmatch('/EF3-?[34]/',Narrative)>0; 
run;
title;

/*PRXCHANGE FUNCTION
US weather stations collect data hourly. 
Many of these stations are located at airports, as indicated in the Name column. 
The word airport might be written out, or it might be abbreviated AP. 
The word International might be abbreviated several ways: uppercase, lowercase, INT or INTL, with or without a period. 
We want to standardize the data, replacing the abbreviations with International Airport.

You can use the PRXCHANGE function to locate a pattern match and perform a substitution. 
PRXCHANGE has three arguments: The first is the Perl regular expression, which can be specified as a constant, a column, or a pattern identifier returned by the PRXPARSE function. 
							   The second argument is a numeric value that specifies the number of times to search for and replace the matching pattern. 
									If the value is negative 1, SAS replaces every occurrence of the pattern in the source string. 
							   The third argument is the source string to be searched.
	
	PRXCHANGE(perl-regex, times, source);

Perl regular expressions for pattern-matching replacement must include the letter s before the starting pattern delimiter. 
You can thi7nk of the s as substitution.
	's/ AP / AIRPORT /'

So this regular expression begins with an s followed by the starting delimiter, the pattern, another slash delimiter, the replacement string, and the ending delimiter.
We're looking for a space followed by uppercase AP followed by a space. 
When that pattern is found, the matching characters in source are replaced by a space, the uppercase word AIRPORT, and a space.

	's/ INT( |L |L.  )/ INTERNATIONAL / i'
This pattern searches for a space followed by INT, followed by three possibilities: only a space, the letter L and a space, or an L, a period, and a space.
If any of these patterns are found, the matching text is replaced with space International space. 
But we need to be case insensitive, so we added the I option after the ending delimiter. Y
You can think of I as "Ignore case" or "case Insensitive." The I option can be uppercase or lowercase.
*/

/*CAPTURE BUFFERS FOR SUBSTITUTION
LongLat: -134.5639@58.3567
		 's/(-?\d+\.\d*)(@) (-?\d+\.\d*)/$3$2$1/'
				$1       $2      $3
LatLong: 58.3567@-134.5639

Recall that parentheses are used for grouping, and we've defined three groups in this pattern.
Parentheses have an added benefit. They create capture buffers to hold the matching text string. 
Each capture buffer is referenced with a dollar sign followed by a sequential number starting at 1. 

In this example, the first set of parentheses creates capture buffer 1, which holds the matching longitude value. 
The second set of parentheses creates capture buffer 2, which holds the matching @ symbol, and the third capture buffer holds the matching latitude value. 

You can refer to the buffer values as $1, $2, and $3. 
We want to rearrange the text so that the third buffer, the latitude, is first, and then the at sign in the second buffer, and then the longitude in the first buffer. 
So the "replace" part of our regular expression is $3$2$1, resulting in latitude@longitude.
*/

data stations;
	set pg3.weather_usstationshourly;
	where State='AK';
	Name_New=prxchange('s/ AP/ AIRPORT/', -1, Name);
	Name_New=prxchange('s/ INT( |L |L.)/ INTERNATIONAL /i', -1, Name_New);
	LatLong=prxchange('s/(-?\d+\.\d*)(@)(-?\d+\.\d*)/$3$2$1/', -1, LongLat);
run;

data tornadoEF;
    set pg3.tornado_2017narrative;
    length Narrative_New $ 4242;
    Pos=prxmatch('/EF-/',Narrative);
    Narrative_New=prxchange('s/EF-/EF/',-1,Narrative);
run;

title 'US Tornados';
proc print data=tornadoEF;
run;
title;
	


