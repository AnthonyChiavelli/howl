Brainfuck Interpreter
=========

A yet-unnamed perl script that interprets brainfuck source code. Specify the -f flag on the 
command line followed by the source code file to interpret. I will henceforth refer to it as
NBI for nameless brainfuck interpreter. So far, NBI catches most errors and displays a helpful
error message with line/column number and nature of error.

**USAGE**
* Specify bf file wiht -f flag
* When no -f flag is present, NBI will read from STDIN (no inputting allowed as of yet)
* When -c (filename) is present, NBI will convert the brainfuck into C then compile it
* When -s (filename) is present, NBI will convert the brainfuck into C


**COMING SOON**

* When -d flag is present, NBI will enter debug mode. In debug mode
  * Pressing enter will step through instructions
  * Pressing space will execute up until the next breakpoint (a special char in source, maybe !)
  * At every point, the state of the program will be displayed (pointer location, value at pointer, paren stack, etc)
  * The current to-be-executed-next symbol will be highlighted in some way
