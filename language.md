### Ash Language

There are some fairly simple principles:
* everything is an expression
* a code block is a series of expressions seperated by semicolons
* the program is a code block
* the last expression of a code block is returned
* for function application, `f x y` means `f(x,y)`

```
// this is a comment

// Literals
// Ash has the following kinds of literals

// Literal numbers are integers or decimals.
0; 1; -3.54;

// Strings must be between double quotes.
"hello world";
"you can escape the \" character with a backslash";

// Lists are written the same way as JS
[1, 2, "list members don't have to be all the same type", [3, 4]];

// You can quote an expression by preceding it with a single quote. This transforms it into a list representing that expression
// Quoting is useful mainly for writing macros
'1;
// equivalent to
["number", "1"];

'(f x + 2);
// equivalent to
["function-application", ["operator", "op_plus"],
  ["function-application", ["variable", "f"],
    ["variable", "x"]],
  ["number", "1"]];

// If you quasi-quote instead, using a backtick, you can then embed code to be evaluated again by preceding it with an @
`(3 + @(1 + 1));
// equivalent to
["function-application", ["operator", "op_plus"],
  ["number" "3"],
  2]; // the result of evaluating the unquoted part

// There's also a kind of sort-of-literal, the javascript literal
// code enclosed in ~{ ... }~  will be passed through the compiler as javascript to put in the final compiled output
// shouldn't be used unless you're willing to go through the compiled code to debug
1 + ~{ Math.pow(2,3); }~; // 9

// Function Calls

// function calls are done just by writing the arguments to the function after its name:
print "hello world";
add 1 2;

// functions are implicitly partially applied - if there aren't enough arguments, instead of throwing an error a function will return
// a new function that takes the remaining arguments and does what the original would have done with them
add_one = add 1;
add_one 2; // returns 3

// Assignment

// assignment is done with the = operator.
x = 3

// function definitions are done just by putting the functions arguments on the name side
triple x = x * 3
// for multiple expressions in a function, they must be wrapped in brackets. the value of the last expression is what gets returned.
print_and_double x = (print x; x * 2)
```
