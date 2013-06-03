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

#Array of values, initialized to zero
my @table=((0) x $TABLE_SIZE);

#Current pointer
my $ptr;

#Holds symbols read in
my $symbol;

#Read byte by byte until EOF
while (read INFILE, $symbol, 1) {
  #Call the function corresponding to the symbol
  if (exists($symbol_table{$symbol})) {
    #Treat the value string in the map as a function
    #name and call it
    &{$symbol_table{$symbol}}();
  }
  #Throw error and quit on invalid symbol
  elsif (not_whitespace($symbol)) {
    die $!;
  }
}

sub not_whitespace {
  if ($_[0] eq " " || $_[0] eq "\t" || $_[0] eq "\n") {
    return 0;
  }
  return 1;
}

sub output_val {
  
}

