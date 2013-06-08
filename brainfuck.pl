#!/usr/bin/perl

#use strict;
use warnings;

#Command line arg parser
#use Getopt::Std;
use Getopt::Long;

#function declarations
sub inc_ptr;
sub dec_ptr;
sub inc_val;
sub dev_val;
sub output_val;
sub input_val;
sub cond_z;
sub cond_nz;
sub not_whitespace;

#Because I'm still a C programmer at heart
my $TABLE_SIZE = 5000;

#Array for command line args
my %opts=();

#Parse for flags and args
GetOptions('f|file=s' => \$file,
           'c|compile=s' => \$exec_file,
           's|source=s' => \$c_file,
           'h|help|usage' => \$wants_help,
           'a|ascii' => \$ascii_mode);

if ($wants_help) {
  print "\nUsage:\n";
  print "  -f | --file <file>    :    Execute file (else STDIN is used)\n";
  print "  -h | --help           :    Display this message\n"; 
  print "  -c | --compile        :    Compile code via gcc into executable\n";
  print "  -s | --source <file>  :    Translate into C source code and output into file\n";
  print "  -a | --ascii          :    Print ascii values instead of chars\n";
  print "  -d | --debug          :    Not implemented yet\n";
  exit(0);
}

#If a file name was given
if ($file) {
  #Open, or on error, die and store error in $!
  open INFILE, $file or die "\nError: Could not open file $file";
}
else {
  #Duplicate STDIN handle
  open(INFILE, "<&STDIN") or die "\nError: Could not duplicate STDIN: $!";
}

#If compiling, we also need source
if ($exec_file) {
  $c_file= "a.c";
}

#Create a hash mapping symbols to functions
my %symbol_table = (
  ">" => "inc_ptr",
  "<" => "dec_ptr",
  "+" => "inc_val",
  "-" => "dec_val",
  "." => "output_val",
  "," => "input_val",
  "[" => "cond_z",
  "]" => "cond_nz"
);

#A hash mapping symbols to equivalent c code
my %c_table = (
  ">" => "ptr++;\n",
  "<" => "ptr--;\n",
  "+" => "(*ptr)++;\n",
  "-" => "(*ptr)--;\n",
  "." => "putchar(*ptr);\n",
  "," => "*ptr = getchar();\n",
  "[" => "while (*ptr) {\n",
  "]" => "}\n"
);

#Keep track of line and column for error reporting
my $line = 1;
my $col = 1;

#Bracket location stack
@bracket_stack = ();

#Array of values, initialized to zero
my @table=((0) x $TABLE_SIZE);

#Current pointer
my $ptr = 0;

#Holds symbols read in
my $symbol;

#If specified, write to C file
if ($c_file) {
  #C Boiler plate
  my $HEAD = "#include<stdio.h>\n
              #include<stdlib.h>\n
              main() {\n 
              char *ptr = malloc($TABLE_SIZE);\n";
  my $TAIL = "}";
  #Open and write
  open(CFILE, ">".$c_file);
  print CFILE $HEAD;
  while (read INFILE, $symbol, 1) {
    #Track column and line for error reporting
    $col++;
    if ($symbol eq "\n") {
      $col = 1;
      $line++;
    }
    #Write out a line of C
    if (exists($c_table{$symbol})) {
      print CFILE $c_table{$symbol};
    } 
    elsif (not_whitespace($symbol)) {
      print "\nError: invalid symbol '$symbol' encountered at $line:$col\n";
      exit(1);
    }
  }
  print CFILE $TAIL;
}

#Compile c source file
if ($exec_file) {
  print "/usr/bin/gcc -o $exec_file $c_file\n";
  `/usr/bin/gcc -o $exec_file $c_file`;
  unlink($c_file);
  #Exit with error code from gcc
  exit($?);
}

#------Main loop for execution-------
#Read byte by byte until EOF
while (read INFILE, $symbol, 1) {
  #Call the function corresponding to the symbol
  if (exists($symbol_table{$symbol})) {
    #Treat the value string in the map as a function
    #name and call it
    &{$symbol_table{$symbol}}();
    #Update column number
    $col++;
  }
  #Update the line number
  elsif ($symbol eq "\n") {
    $line++;
    $col = 1;
  }
  #Throw error and quit on invalid symbol
  elsif (not_whitespace($symbol)) {
    print "\nError: Invalid Symbol '$symbol' encountered at $line:$col\n";
    exit(1);
  }
}

#Returns true if the 1-char string passed is NOT whitespace
sub not_whitespace {
  if ($_[0] eq " " || $_[0] eq "\t" || $_[0] eq "\n") {
    return 0;
  }
  return 1;
}

#Get a value from stdin, store it at pointer
sub input_val {
  print ">";
  my $char;
  my $input = <STDIN>;
  #Match number
  if ($input =~ /(\d+)/) {
    $table[$ptr] = $input;
  }
  #Match single-quoted char
  elsif ($input =~ /'.{1}'/) {
    $table[$ptr] = ord(substr($input, 1));
  }
  else {
    print "Invalid input character. Please input a number or single-quoted ascii character\n";
    input_val();
  }
}

#Print out value at pointer as ascii character
sub output_val {
  if ($ascii_mode) {
    print $table[$ptr];
  }
  else {
    print chr($table[$ptr]);
  }
}


#Move the pointer to the right
sub inc_ptr{
  $ptr++;
  if ($ptr > $TABLE_SIZE) {
    print "\nError: Out of Bounds (pointer > table size limit) at $line:$col\n";
    exit(2);
  }
}

#Move the pointer to the left
sub dec_ptr{
  $ptr--;
  if ($ptr < 0) {
    print "\nError: Out Of Bounds (pointer < 0) at $line:$col\n";
    exit(2);
  } 
}

#Increment the value at the pointer
sub inc_val{
  $table[$ptr]++;
}

#Decrement the value at the pointer
sub dec_val{
  $table[$ptr]--;
}

#[ encountered
sub cond_z {
  #Keep track of last [
  push(@bracket_stack, tell(INFILE)-1); 
  #Perform conditional seek to corresponding
  #closing bracket
  if ($table[$ptr] == 0) {
    my $byte = "";
    while ($byte ne "]") {
      #Read chars in, dying if EOF is reached
      if (read (INFILE, $byte, 1) == 0) {
        print "\nError: No closing ] for [ at $line:$col\n";
        exit(3);
      }
    }
    pop(@bracket_stack);
  }
}

#] encountered
sub cond_nz {
  #If the value at the ptr is nonzero, jump
  #to after the matching [
  $last_bracket = pop(@bracket_stack);
  seek (INFILE, $last_bracket, 0);
}
