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
sub is_whitespace;

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
  elsif (!is_whitespace($symbol)) {
    die $!;
  }
}

