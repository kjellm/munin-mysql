use Test::More tests => 3;
use Test::Exception;
use FindBin;

# Both mysql_ and Test::More defines the sub skip. Put mysql_ in its
# own package so it don't polute the main:: name space
package mysql_;
Test::More::require_ok("$FindBin::Bin/../mysql_"); 
package main;

sub dump_data {
    use Data::Dumper;
    my %ib = ();
    for my $k (grep /ib/, keys %$mysql_::data) {
        $ib{$k} = $mysql_::data->{$k};
    }
    print Dumper(\%ib);
}

sub slurp {
    my ($file_name) = @_;
    open my $file, '<', $file_name or die($!);
    return do { local $/; <$file> };
}

dies_ok { mysql_::parse_innodb_status('x') } 
    'Not a valid innodb status should die';

lives_ok {
    for my $file (glob "$FindBin::Bin/innodb-status-*.txt") {
        $mysql_::data = {};
        mysql_::parse_innodb_status(slurp($file));

        # FIX test that the correct values is extracted
        #dump_data();
    }
} 'All status files should parse';
