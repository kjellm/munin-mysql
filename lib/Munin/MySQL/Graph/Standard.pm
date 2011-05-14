package Munin::MySQL::Graph::Standard;

use warnings;
use strict;

use POSIX qw(floor);

sub graphs { return {

    bin_relay_log => {
        config => {
            global_attrs => {
                title  => 'Binary/Relay Logs',
                vlabel => 'Log activity',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'Binlog_cache_disk_use', label => 'Binlog Cache Disk Use',
                                              info  => 'The number of transactions that used the temporary binary log cache but that exceeded the value of binlog_cache_size and used a temporary file to store statements from the transaction.'},
            {name => 'Binlog_cache_use',      label => 'Binlog Cache Use',
                                              info  => 'The number of transactions that used the temporary binary log cache.'},
            {name => 'ma_binlog_size',        label => 'Binary Log Space (GB)',
                                              info  => 'The total combined size of all existing binary logs in GB',
                                              type  => 'GAUGE',
                                              cdef  => 'ma_binlog_size,1024,/,1024,/,1024,/'},
            {name => 'relay_log_space',       label => 'Relay Log Space (GB)',
                                              info  => 'The total combined size of all existing relay logs in GB.',
                                              type  => 'GAUGE',
                                              cdef  => 'relay_log_space,1024,/,1024,/,1024,/'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    commands => {
        config => {
            global_attrs => {
                title  => 'Command Counters',
                vlabel => 'Commands per ${graph_period}',
                total  => 'Questions',
            },
            data_source_attrs => {},
        },
        data_sources => [
            {name => 'Com_replace_select', label => 'Replace select',  colour=>'00B99B'},
            {name => 'Com_update_multi',   label => 'Update multi',    colour=>'D8ACE0'},
            {name => 'Com_insert_select',  label => 'Insert select',   colour=>'AAABA1'},
            {name => 'Com_delete_multi',   label => 'Delete multi',    colour=>'942D0C'},
            {name => 'Com_load',           label => 'Load Data',       colour=>'55009D'},
            {name => 'Com_delete',         label => 'Delete',          colour=>'FF7D00'},
            {name => 'Com_replace',        label => 'Replace',         colour=>'2175D9'},
            {name => 'Com_update',         label => 'Update',          colour=>'00CF00'},
            {name => 'Com_insert',         label => 'Insert',          colour=>'FFF200'},
            {name => 'Com_select',         label => 'Select',          colour=>'FF0000'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    connections => {
        config => {
            global_attrs => {
                title  => 'Connections',
                vlabel => 'Connections per ${graph_period}',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'max_connections',      label  => 'Max connections', 
                                             type   => 'GAUGE',
                                             draw   => 'AREA',
                                             colour => 'cdcfc4',
                                             info   => 'The number of simultaneous client connections allowed.'},
            {name => 'Max_used_connections', label  => 'Max used',
                                             type   => 'GAUGE',
                                             draw   => 'AREA',
                                             colour => 'ffd660',
                                             info   => 'The maximum number of connections that have been in use simultaneously since the server started.'},
            {name => 'Aborted_clients',      label  => 'Aborted clients',
                                             info   => 'The number of connections that were aborted because the client died without closing the connection properly.'},
            {name => 'Aborted_connects',     label  => 'Aborted connects',
                                             info   => 'The number of failed attempts to connect to the MySQL server.'},
            {name => 'Threads_connected',    label  => 'Threads connected',
                                             type   => 'GAUGE',
                                             info   => 'The number of currently open connections.'},
            {name => 'Connections',          label  => 'New connections',
                                             info   => 'The number of connection attempts (successful or not) to the MySQL server.'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    files_tables => {
        config => {
            global_attrs => {
                title  => 'Files and tables',
                vlabel => 'Tables',
            },
            data_source_attrs => {
                type  => 'GAUGE',
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'table_open_cache', label  => 'Table cache',
                                         draw   => 'AREA',
                                         colour => 'cdcfc4',
                                         info   => 'The number of open tables for all threads.'},
            {name => 'Open_files',       label  => 'Open files',
                                         info   => 'The number of files that are open.'},
            {name => 'Open_tables',      label  => 'Open tables',
                                         info   => 'The number of tables that are open.'},
            {name => 'Opened_tables',    label  => 'Opened tables',
                                         type   => 'DERIVE',
                                         info   => 'The number of tables that have been opened.'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    handlers => {
        config => {
            global_attrs => {
                title  => 'Handlers',
            },
            data_source_attrs => {
                draw  => 'AREASTACK',
            },
        },
        data_sources => [
            {name => 'Handler_write',        label  => 'Handler write',
                                             colour => '4D4A47',
                                             info   => 'The number of requests to insert a row in a table.'},
            {name => 'Handler_update',       label  => 'Handler update',
                                             colour => 'C79F71',
                                             info   => 'The number of requests to update a row in a table.'},
            {name => 'Handler_delete',       label  => 'Handler delete',
                                             colour => 'BDB8B3',
                                             info   => 'The number of requests to delete a row in a table.'},
            {name => 'Handler_read_first',   label  => 'Handler Read First',
                                             colour => '8C286E',
                                             info   => 'The number of times the first entry was read from an index. If this is high, it suggests that the server is doing a lot of full index scans.'},
            {name => 'Handler_read_key',     label  => 'Handler Read Key',
                                             colour => 'BAB27F',
                                             info   => 'The number of requests to read a row based on a key. If this is high, it is a good indication that your queries and tables are properly indexed.'},
            {name => 'Handler_read_next',    label  => 'Handler Read Next',
                                             colour => 'C02942',
                                             info   => 'The number of requests to read the next row in key order. This is incremented if you are querying an index column with a range constraint or if you are doing an index scan.'},
            {name => 'Handler_read_prev',    label  => 'Handler Read Prev',
                                             colour => 'FA6900',
                                             info   => 'The number of requests to read the previous row in key order. This read method is mainly used to optimize ORDER BY ... DESC.'},
            {name => 'Handler_read_rnd',     label  => 'Handler Read Random',
                                             colour => '5A3D31',
                                             info   => 'The number of requests to read a row based on a fixed position. This is high if you are doing a lot of queries that require sorting of the result. You probably have a lot of queries that require MySQL to scan whole tables or you have joins that don\'t use keys properly.'},
            {name => 'Handler_read_rnd_next',label  => 'Handler Read Random Next',
                                             colour => '69D2E7',
                                             info   => 'RThe number of requests to read the next row in the data file. This is high if you are doing a lot of table scans. Generally this suggests that your tables are not properly indexed or that your queries are not written to take advantage of the indexes you have.'},
    
        ],
    },
    
      
    #---------------------------------------------------------------------
    
    network_traffic => {
        config => {
            global_attrs => {
                title  => 'Network Traffic',
                args   => "--base 1024",
                vlabel => 'Bytes received (-) / sent (+) per ${graph_period}',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'Bytes_received', label => 'Bytes transfered',
                                       graph => 'no',
                                       info  => 'The number of bytes received from all clients.'},
            {name => 'Bytes_sent',     label    => 'Bytes transfered',
                                       negative => 'Bytes_received',
                                       info     => 'The number of bytes sent to all clients.'},
        ],
    },
      
    #---------------------------------------------------------------------
    
    processlist => {
        config => {
            global_attrs => {
                title  => 'Processlist states',
                vlabel => 'State count per ${graph_period}',
            },
            data_source_attrs => {
            },
        },
        data_sources => [
            {name => 'State_closing_tables',       label => 'Closing tables',
                                                   info  => 'The thread is flushing the changed table data to disk and closing the used tables.',
                                                   colour=> 'DE0056'},
            {name => 'State_copying_to_tmp_table', label => 'Copying to tmp table',
                                                   info  => 'The thread is processing an ALTER TABLE statement. This state occurs after the table with the new structure has been created but before rows are copied into it.',
                                                   colour=> '784890'},
            {name => 'State_end',                  label => 'End',
                                                   info  => 'This occurs at the end but before the cleanup of ALTER TABLE, CREATE VIEW, DELETE, INSERT, SELECT, or UPDATE statements.',
                                                   colour=> 'D1642E'},
            {name => 'State_freeing_items',        label => 'Freeing items',
                                                   info  => 'The thread has executed a command. This state is usually followed by cleaning up.',
                                                   colour=> '487860'},
            {name => 'State_init',                 label => 'Init',
                                                   info  => 'This occurs before the initialization of ALTER TABLE, DELETE, INSERT, SELECT, or UPDATE statements.',
                                                   colour=> '907890'},
            {name => 'State_locked',               label => 'Locked',
                                                   info  => 'The query is locked by another query.',
                                                   colour=> 'DE0056'},
            {name => 'State_login',                label => 'Login',
                                                   info  => 'The initial state for a connection thread until the client has been authenticated successfully.',
                                                   colour=> '1693A7'},
            {name => 'State_preparing',            label => 'Preparing',
                                                   info  => 'This state occurs during query optimization.',
                                                   colour=> '783030'},
            {name => 'State_reading_from_net',     label => 'Reading from net',
                                                   info  => 'The server is reading a packet from the network.',
                                                   colour=> 'FF7F00'},
            {name => 'State_sending_data',         label => 'Sending data',
                                                   info  => 'The thread is processing rows for a SELECT statement and also is sending data to the client.',
                                                   colour=> '54382A'},
            {name => 'State_sorting_result',       label => 'Sorting result',
                                                   info  => 'For a SELECT statement, this is similar to Creating sort index, but for nontemporary tables.',
                                                   colour=> 'B83A04'},
            {name => 'State_statistics',           label => 'Statistics',
                                                   info  => 'The server is calculating statistics to develop a query execution plan. If a thread is in this state for a long time, the server is probably disk-bound performing other work.',
                                                   colour=> '6E3803'},
            {name => 'State_updating',             label => 'Updating',
                                                   info  => 'The thread is searching for rows to update and is updating them.',
                                                   colour=> 'B56414'},
            {name => 'State_writing_to_net',       label => 'Writing to net',
                                                   info  => 'The server is writing a packet to the network.',
                                                   colour=> '6E645A'},
            {name => 'State_none',                 label => 'None',
                                                   info  => '',
                                                   colour=> '521808'},
            {name => 'State_other',                label => 'Other',
                                                   info  => '',
                                                   colour=> '194240'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    select_types => {
        config => {
            global_attrs => {
                title  => 'Select types',
                vlabel => 'Commands per ${graph_period}',
                total  => 'Total',
            },
            data_source_attrs => {},
        },
        data_sources => [
            {name => 'Select_full_join',       label => 'Full join',
                                               info  => 'The number of joins that perform table scans because they do not use indexes.',
                                               colour=> 'FF0000'},
            {name => 'Select_full_range_join', label => 'Full range',
                                               info  => 'The number of joins that used a range search on a reference table.',
                                               colour=> 'FF7D00'},
            {name => 'Select_range',           label => 'Range',
                                               info  => 'The number of joins that used ranges on the first table.',
                                               colour=> 'FFF200'},
            {name => 'Select_range_check',     label => 'Range check',
                                               info  => 'The number of joins without keys that check for key usage after each row.',
                                               colour=> '7DFF7D'},
            {name => 'Select_scan',            label => 'Scan',
                                               info  => 'The number of joins that did a full scan of the first table.',
                                               colour=> '7D7DFF'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    slow => {
        config => {
            global_attrs => {
                title  => 'Slow Queries',
                vlabel => 'Slow queries per ${graph_period}',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'Slow_queries', label => 'Slow queries',
                                     info  => 'The number of queries that have taken more than long_query_time seconds.'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    sorts => {
        config => {
            global_attrs => {
                title  => 'Sorts',
                vlabel => 'Sorts / ${graph_period}',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'Sort_rows',         label => 'Rows sorted (K)',
                                          info  => 'The number of sorted rows.',
                                          cdef  => 'Sort_rows,1024,/',
                                          draw  => 'AREA',
                                          colour=> 'FF7D00'},
            {name => 'Sort_range',        label => 'Range',
                                          info  => 'The number of sorts that were done using ranges.',
                                          colour=> '007D00'},
            {name => 'Sort_merge_passes', label => 'Merge passes',
                                          info  => 'The number of merge passes that the sort algorithm has had to do.',
                                          colour=> '7D0000'},
            {name => 'Sort_scan',         label => 'Scan',
                                          info  => 'The number of sorts that were done by scanning the table.',
                                          colour=> '0000D0'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    table_locks => {
        config => {
            global_attrs => {
                title  => 'Table locks',
                vlabel => 'locks per ${graph_period}',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'Table_locks_immediate', label => 'Table locks immed',
                                              info  => 'The number of times that a request for a table lock could be granted immediately.'},
            {name => 'Table_locks_waited',    label => 'Table locks waited',
                                              info  => 'The number of times that a request for a table lock could not be granted immediately and a wait was needed.'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    threads => {
        config => {
            global_attrs => {
                title  => 'Threads',
                vlabel => 'Threads created',
            },
            data_source_attrs => {
            },
        },
        data_sources => [
            {name => 'thread_cache_size', label => 'Thread cache size',
                                          draw  => 'AREA',
                                          type  => 'GAUGE',
                                          info  => 'How many threads the server should cache for reuse',
                                          colour=> '99ff99'},
            {name => 'Threads_created',   label => 'Threads created',
                                          draw  => 'LINE1',
                                          type  => 'GAUGE',
                                          info  => 'The number of threads created to handle connections',
                                          colour=> '0000ff'},
            {name => 'Threads_connected', label => 'Threads connected',
                                          draw  => 'LINE1',
                                          type  => 'GAUGE',
                                          info  => 'The number of currently open connections',
                                          colour=> '7777ff'},
            {name => 'Threads_running',   label => 'Threads running',
                                          draw  => 'LINE1',
                                          type  => 'GAUGE',
                                          info  => 'The number of threads that are not sleeping',
                                          colour=> '7d0000'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    tmp_tables => {
        config => {
            global_attrs => {
                title  => 'Temporary objects',
                vlabel => 'Objects per ${graph_period}',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'Created_tmp_disk_tables', label => 'Temp disk tables',
                                                info  => 'The number of internal on-disk temporary tables created by the server while executing statements.'},
            {name => 'Created_tmp_tables',      label => 'Temp tables',
                                                info  => 'The number of internal temporary tables created by the server while executing statements.'},
            {name => 'Created_tmp_files',       label => 'Temp files',
                                                info  => 'How many temporary files mysqld has created.'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    uptime => {
        config => {
            global_attrs => {
                title  => 'Uptime',
                vlabel => 'Uptime in days',
            },
            data_source_attrs => {
                draw  => 'AREA',
                type  => 'GAUGE',
            },
        },
        data_sources => [
            {name => 'Uptime_days', label => 'Uptime',
                                    info  => 'Server uptime in days.',
                                    value => sub {
                                        floor($_[0]->{Uptime} / 86400); # seconds in a day
                                    },
            },
        ],
    },
}}

1;

