package Munin::MySQL::Graph::ReplicationSlave;

use warnings;
use strict;

sub graphs { return {
    replication => {
        config => {
            global_attrs => {
                title  => 'Replication',
                vlabel => 'Activity',
            },
            data_source_attrs => {
                draw => 'LINE1',
            },
        },
        data_sources => [
            {name => 'slave_running',              label => 'Slave Running',
                                                   type  => 'GAUGE',
                                                   draw  => 'AREA',
                                                   colour=> '00AA00'},
            {name => 'slave_stopped',              label => 'Slave Stopped',
                                                   type  => 'GAUGE',
                                                   draw  => 'AREA',
                                                   colour=> 'DD0000'},
            {name => 'Slave_retried_transactions', label => 'Retried Transactions',
                                                   info  => 'The total number of times since startup that the replication slave SQL thread has retried transactions.'},
            {name => 'Slave_open_temp_tables',     label => 'Open Temp Tables',
                                                   info  => 'The number of temporary tables that the slave SQL thread currently has open.'},
            {name => 'seconds_behind_master',      label => 'Secs Behind Master', 
                                                   type  => 'GAUGE',
                                                   info  => 'http://dev.mysql.com/doc/refman/5.1/en/show-slave-status.html'},
        ],
    },
}}

1;

