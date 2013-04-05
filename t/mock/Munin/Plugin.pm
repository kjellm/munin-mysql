package Munin::Plugin;

use warnings;
use strict;

use Exporter;

our @ISA = ('Exporter');
our @EXPORT = qw(clean_fieldname need_multigraph print_thresholds);


sub clean_fieldname {
    my ($fn) = @_;

    return $fn;
}


sub need_multigraph { 1; }


sub print_thresholds { 1; }


1;
