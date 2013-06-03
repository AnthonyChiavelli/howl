#use strict;
use warnings;

#Command line arg parser
use Getopt::Std;

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

#Pseudo-constants because I'm still in C mode despite this
#being perl #yolo
my $TABLE_SIZE = 5000;

#Array for command line args
my %opts=();
#Parse for flags and args
getopts("f:", \%opts);


#If a file name was given
if ($opts{f}) {
  #Open, or on error, die and store error in $!
  open INFILE, $opts{f} or die $!;
}
#TODO: else, read from stdin

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

#Keep track of line and column for error reporting
my $line = 1;
my $col = 1;

#Array of values, initialized to zero
my @table=((0) x $TABLE_SIZE);

#Current pointer
my $ptr = 0;

#Holds symbols read in
my $symbol;

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
    print "Error: Invalid Symbol \"$symbol\" encountered at $line:$col\n";
    die $!;
  }
}

#Returns true if the 1-char string passed is NOT whitespace
sub not_whitespace {
  if ($_[0] eq " " || $_[0] eq "\t" || $_[0] eq "\n") {
    return 0;
  }
  return 1;
}

#Get a byte from stdin, store it as ascii val at pointer
sub input_val {
  print ">";
  my $byte;
  read(STDIN, $byte, 1);
  $table[$ptr] = ord($byte);
}

#Print out value at pointer as ascii character
sub output_val {
  print chr($table[$ptr]);
}

#Move the pointer to the right
sub inc_ptr{
  $ptr++;
  if ($ptr > $TABLE_SIZE) {
    print "\nError: Out of Bounds (pointer > table size limit) at $line:$col\n";
    die $!;
  }
}

#Move the pointer to the left
sub dec_ptr{
  $ptr--;
  if ($ptr < 0) {
    print "\nError: Out Of Bounds (pointer < 0) at $line:$col\n";
    die $!;
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


