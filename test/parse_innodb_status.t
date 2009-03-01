use Test::More tests => 2;
use Test::Exception;
use FindBin;

# Both mysql_ and Test::More defines the sub skip. Put mysql_ in its
# own package so it don't polute the main:: name space
package mysql_;
require('mysql_'); # Test::More::require_ok doesn't work. Tries to
                   # load mysql_.pm
package main;

sub dump_data {
    use Data::Dumper;
    my %ib = ();
    for my $k (grep /ib/, keys %$mysql_::data) {
        $ib{$k} = $mysql_::data->{$k};
    }
    print Dumper(\%ib);
}

dies_ok { mysql_::parse_innodb_status('x') } 
    'Not a valid innodb status should die';

lives_ok {
    for my $file (glob "$FindBin::Bin/innodb-status-*.txt") {
        $mysql_::data = {};
        open my $ish, '<', $file or die($!);
        my $is = do { local $/; <$ish> };
        mysql_::parse_innodb_status($is);

        # FIX test that the correct values is extracted
        #dump_data();
    }
} 'All status files should parse';


