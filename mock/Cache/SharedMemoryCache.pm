use warnings;
use strict;

package Cache::SharedMemoryCache;

sub new {
    my $class = shift;
    return bless {}, $class;
}

sub get {}
sub set {}


1;
