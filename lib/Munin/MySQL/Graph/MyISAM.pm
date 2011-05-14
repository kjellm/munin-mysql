package Munin::MySQL::Graph::MyISAM;

use warnings;
use strict;

sub graphs { return {
    myisam_indexes => {
        config => {
            global_attrs => {
                title  => 'MyISAM Indexes',
                vlabel => 'Requests per ${graph_period}',
            },
            data_source_attrs => {
                draw  => 'LINE1',
                min   => '',
            },
        },
        data_sources => [
            {name => 'Key_read_requests',  label => 'Key read requests',
                                           info  => 'The number of requests to read a key block from the cache.',
                                           draw  => 'AREA',
                                           colour => '008800',
                                           min    => '0'},
            {name => 'Key_reads',          label => 'Key reads', 
                                           info  => 'The number of physical reads of a key block from disk.',
                                           colour => '00FF00',
                                           min    => '0'},
            # plot as negative as long as munin does not support different colours for above and below the line
            {name => 'Key_write_requests', label => 'Key write requests',
                                           info  => 'The number of requests to write a key block to the cache.',
                                           cdef  => 'Key_write_requests,-1,*',
                                           draw  => 'AREA',
                                           colour => '880000'},
            {name => 'Key_writes',         label => 'Key writes',
                                           info  => 'The number of physical writes of a key block to disk.',
                                           cdef  => 'Key_writes,-1,*',
                                           colour => 'FF0000'},
       ],
    },
    
    #---------------------------------------------------------------------
    
    myisam_key_cache => {
        config => {
            global_attrs => {
                title  => 'MyISAM Key Cache',
                vlabel => 'Bytes',
            },
            data_source_attrs => {
                type  => 'GAUGE',
            },
        },
        data_sources => [
            {name => 'key_buffer_size',    label  => 'Key buffer size',
                                           draw   => 'AREA',
                                           colour => '99B898'},
            {name => 'Key_buf_unused',     label  => 'Key buffer bytes unused',
                                           draw   => 'AREA',
                                           colour => '2A363B',
                                           value  => sub {
                                                         $_[0]->{Key_blocks_unused} * $_[0]->{key_cache_block_size}
                                                     }},
            {name => 'Key_buf_unflush',    label  => 'Key buffer bytes unflushed',
                                           draw   => 'AREA',
                                           colour => 'FECEA8',
                                           value  => sub {
                                                         $_[0]->{Key_blocks_not_flushed} * $_[0]->{key_cache_block_size}
                                                     }},
        ],
    },
}}

1;

