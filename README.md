Howl
=========

Howl is a [brainfuck](http://esolangs.org/wiki/brainfuck) interpreter written in perl. It is capable
of reading in BF source code and generating appropriate output. Invalid characters are reported along
with line/column number. Input may be read from STDIN, and howl will still input characters from the
user through STDIN as needed in the execution of the program. Howl may also translate BF source to C
source code, and/or compile it with gcc. 

In the next release, debugging mode will be implemented. In this mode, execution will proceed up to
user-set break points, or proceed symbol-wise, showing the state of the machine at all times. 


**USAGE**

Usage:

  -f | --file <file>    :    Execute file (else STDIN is used)
  
  -h | --help           :    Display this message
  
  -c | --compile        :    Compile code via gcc into executable
  
  -s | --source <file>  :    Translate into C source code and output into file
  
  -a | --ascii          :    Print ascii values instead of chars
  
  -d | --debug          :    Not implemented yet
  


**COMING SOON**

* When -d flag is present, NBI will enter debug mode. In debug mode
  * Pressing enter will step through instructions
  * Pressing space will execute up until the next breakpoint (a special char in source, maybe !)
  * At every point, the state of the program will be displayed (pointer location, value at pointer, paren stack, etc)
  * The current to-be-executed-next symbol will be highlighted in some way
