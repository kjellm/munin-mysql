use warnings;
use strict;

package DBI;

our %results;
require 'mysql_51_data.pm';

sub connect {
    my ($class) = @_;

    my $self = {
        prepared_query => '',
        result         => '',
        cursor         => 0,
    };
    
    return bless $self, $class;
}

sub prepare {
    my ($self, $query) = @_;
    $self->{prepared_query} = $query;

    return $self;
}

sub execute {
    my ($self) = @_;

    $self->{cursor} = 1;
    $self->{result} = $results{$self->{prepared_query}};

    return $self;
}

sub finish {}

sub fetch {
    my ($self) = @_;

    my $row_hash = $self->fetchrow_hashref();
    return unless $row_hash;

    my @row = @$row_hash{@{$self->{result}[0]}};
    return \@row;
}

sub fetchrow_hashref {
    my ($self) = @_;

    return unless exists $self->{result}[$self->{cursor}];

    return $self->{result}[$self->{cursor}++];
}

1;
