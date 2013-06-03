use strict;
use warnings;
#Command line arg parser
use Getopt::Std;

#Array for command line args
my %opts=();
#Parse for flags and args
getopts("f:", \%opts);


#If a file name was given
if ($opts{f}) {
  #Open, or on error, die and store error in $!
  open file, opts{f} or die $!
}
#TODO: else, read from stdin






