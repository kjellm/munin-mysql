use Test::More tests => 2;
use Test::Exception;
use FindBin;

package mysql_;
require('mysql_'); # Test::More::require_ok doesn't work. Tries to
                   # load mysql_.pm
package main;

dies_ok { mysql_::parse_innodb_status('x') } 
    'Not a valid innodb status should die';

lives_ok {
    for my $file (glob "$FindBin::Bin/innodb-status-*.txt") {
        open my $ish, '<', $file or die($!);

        my $is = do { local $/; <$ish> };
        mysql_::parse_innodb_status($is);
        # FIX test that the correct values is extracted
    }
} 'All status files should parse';

