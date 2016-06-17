use strict;
use warnings;

use FindBin;
use Path::Class qw(dir);
use Test::More;
use Test::Output qw(:functions);
use Test::Regression;

$ENV{MUNIN_CAP_MULTIGRAPH} = 1;
use lib "$FindBin::Bin/mock";

# Put mysql_ in its own package so it don't polute the main:: name
# space.
package mysql_;
Test::More::require_ok("$FindBin::Bin/../mysql"); 
package main;

sub helper {
    @ARGV = @_;
    return join("\n",sort(split(/\n/, stdout_from(sub {mysql_::main()}))))."\n";
}

no warnings;
*mysql_::plugins = sub {
    my $d = dir("$FindBin::Bin/../lib/Munin/MySQL/Graph/");
    my @plugins = ();
    for my $f ($d->children) {
        next unless $f =~ /\.pm$/;
        require $f;
        my $name = $f->basename;
        $name =~ s/.pm$//;
        push @plugins, 'Munin::MySQL::Graph::' . $name;
    }
    return @plugins;
};
use warnings;

ok_regression(sub { helper },           "$FindBin::Bin/values.out", 'Values');
ok_regression(sub { helper('config') }, "$FindBin::Bin/config.out", 'Config');

done_testing;
