#lang brag

block ::= expression (/";" expression)* /";"?
@expression ::= operator-application | funexp ;; these two are needed for precedence and associativity
@funexp ::= variable | literal | function-application | /"(" block /")"
operator-application ::= funexp operator expression
function-application ::= funexp funexp+
variable ::= SYMBOL
@literal ::= quoted-syntax | quasiquoted-syntax | unquoted-syntax | number | string | list | js-literal
list ::= /"[" (expression (/"," expression)*)? /"]"
quoted-syntax ::= /"'" expression
quasiquoted-syntax ::= /"`" expression
unquoted-syntax ::= /"@" expression
js-literal ::= JSLITERAL
operator ::= OPERATOR
number ::= NUMBER
string ::= STRING