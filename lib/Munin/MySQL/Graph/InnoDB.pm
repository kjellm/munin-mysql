package Munin::MySQL::Graph::InnoDB;

use warnings;
use strict;

sub graphs { return {
    innodb_bpool => {
        config => {
            global_attrs => {
                title  => 'InnoDB Buffer Pool',
                vlabel => 'Pages',
                args   => "--base 1024",
            },
            data_source_attrs => {
                draw => 'LINE1',
                type => 'GAUGE',
            },
        },
        data_sources => [
            {name => 'ib_bpool_size',     label  => 'Buffer pool size',
                                          draw   => 'AREA',
                                          colour => 'ffd660',
                                          info   => 'The total number of buffer pool pages'},
            {name => 'ib_bpool_dbpages',  label  => 'Database pages',
                                          draw   => 'AREA',
                                          colour => 'cdcfc4',
                                          info   => 'The number of used buffer pool pages'},
            {name => 'ib_bpool_free',     label => 'Free pages',
                                          info  => 'The number of unused buffer pool pages'},
            {name => 'ib_bpool_modpages', label => 'Modified pages',
                                          info  => 'The number of "dirty" database pages'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    innodb_bpool_act => {
        config => {
            global_attrs => {
                title  => 'InnoDB Buffer Pool Activity',
                vlabel => 'Activity per ${graph_period}',
                total  => 'Total',
            },
            data_source_attrs => {
                draw => 'LINE1',
            },
        },
        data_sources => [
            {name => 'ib_bpool_read',    label => 'Pages read',
                                         info  => 'Pages read into the buffer pool from disk.'},
            {name => 'ib_bpool_created', label => 'Pages created',
                                         info  => 'Pages created in the buffer pool without reading the corresponding disk page.'},
            {name => 'ib_bpool_written', label => 'Pages written',
                                         info  => 'Pages written to disk from the buffer pool.'},
        ],
    },
    
    
    #---------------------------------------------------------------------
    
    innodb_checkpoint_age => {
        config => {
            global_attrs => {
                title  => 'InnoDB Checkpoint Age',
                vlabel => 'Bytes',
                args   => "--base 1024 -l 0",
            },
            data_source_attrs => {
                draw  => 'AREA',
                type  => 'GAUGE',
            },
        },
        data_sources => [
            {name => 'innodb_log_size',  label  => 'InnoDB log size',
                                         colour => 'cdcfc4',
                                         info   => 'The size in bytes of InnoDB log space.',
                                         value  => sub {
                                             $_[0]->{innodb_log_file_size} * $_[0]->{innodb_log_files_in_group}
                                         }},
            {name => 'ib_log_chkpt_age', label  => 'Uncheckpointed bytes',
                                         colour => 'ffd660',
                                         info   => 'The age in bytes of InnoDB checkpoint.',
                                         value  => sub {
                                             exists $_[0]->{ib_log_chkpt_age}
                                               ? $_[0]->{ib_log_chkpt_age}
                                               : $_[0]->{ib_log_written} - $_[0]->{ib_log_checkpoint}
                                         }},
        ],
    },
    
    #---------------------------------------------------------------------
    
    innodb_history_length => {
        config => {
            global_attrs => {
                title  => 'InnoDB History List',
                vlabel => 'Transactions',
            },
            data_source_attrs => {
                draw  => 'LINE1',
                type  => 'GAUGE',
            },
        },
        data_sources => [
            {name => 'ib_tnx_hist', label => 'History list length',
                                    info  => 'Number of unpurged transactions in undo space.'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    innodb_insert_buf => {
        config => {
            global_attrs => {
                title  => 'InnoDB Insert Buffer',
                vlabel => 'Activity per ${graph_period}',
            },
            data_source_attrs => {
                draw => 'LINE1',
            },
        },
        data_sources => [
            {name => 'ib_ibuf_inserts',    label => 'Inserts',
                                           info  => 'These values shows statistics about how many buffer operations InnoDB has done. The ratio of merges to inserts gives a good idea of how efficient the buffer is.'},
            {name => 'ib_ibuf_merged_rec', label => 'Merged Records'},
            {name => 'ib_ibuf_merges',     label => 'Merges'},
        ],
    },
      
    #---------------------------------------------------------------------
    
    innodb_insert_buf_size => {
        config => {
            global_attrs => {
                title  => 'InnoDB Insert Buffer Size',
                vlabel => 'Pages',
                args   => "-l 0",
            },
            data_source_attrs => {
                draw  => 'LINE1',
                type  => 'GAUGE',
            },
        },
        data_sources => [
            {name => 'ib_ibuf_seg_size', label  => 'Segment size',
                                         draw   => 'AREA',
                                         colour => 'cdcfc4',
                                         info   => 'Allocated size of insert buffer segment.'},
            {name => 'ib_ibuf_size',     label  => 'Unmerged pages',
                                         colour => '0022ff',
                                         info   => 'Number of pages containing unmerged records.'},
            {name => 'ib_ibuf_free_len', label  => 'Free pages',
                                         info   => 'Number of pages which are free.'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    innodb_io => {
        config => {
            global_attrs => {
                title  => 'InnoDB IO',
                vlabel => 'IO operations per ${graph_period}',
            },
            data_source_attrs => {
                draw => 'LINE1',
            },
        },
        data_sources => [
            {name => 'ib_io_read',  label => 'File reads',
                                    info  => 'The number of calls to the OS read function.'},
            {name => 'ib_io_write', label => 'File writes',
                                    info  => 'The number of calls to the OS write function.'},
            {name => 'ib_io_log',   label => 'Log writes',
                                    info  => 'The number of calls to the OS write function that is caused by the log subsystem.'},
            {name => 'ib_io_fsync', label => 'File syncs',
                                    info  => 'The number of calls to the OS fsync function.'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    innodb_io_pend => {
        config => {
            global_attrs => {
                title  => 'InnoDB IO Pending',
                vlabel => 'Pending operations',
            },
            data_source_attrs => {
                draw => 'LINE1',
            },
        },
        data_sources => [
            {name => 'ib_iop_log',         label => 'AIO Log'},
            {name => 'ib_iop_sync',        label => 'AIO Sync'},
            {name => 'ib_iop_flush_bpool', label => 'Buf Pool Flush'},
            {name => 'ib_iop_flush_log',   label => 'Log Flushes'},
            {name => 'ib_iop_ibuf_aio',    label => 'Insert Buf AIO Read'},
            {name => 'ib_iop_aioread',     label => 'Normal AIO Reads'},
            {name => 'ib_iop_aiowrite',    label => 'Normal AIO Writes'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    innodb_log => {
        config => {
            global_attrs => {
                title  => 'InnoDB Log',
                vlabel => 'Log activity per ${graph_period}',
            },
            data_source_attrs => {
                draw => 'LINE1',
            },
        },
        data_sources => [
            {name => 'innodb_log_buffer_size', label  => 'Buffer Size',
                                               type   => 'GAUGE',
                                               draw   => 'AREA',
                                               colour => 'fafd9e',
                                               info   => 'The size in bytes of the buffer that InnoDB  uses to write to the log files on disk.'},
            {name => 'ib_log_flush',           label => 'KB Flushed',
                                               info  => 'Number of bytes flushed to the transaction log file.'},
            {name => 'ib_log_written',         label => 'KB Written',
                                               info  => 'Number of bytes written to the transaction log buffer.'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    innodb_rows => {
        config => {
            global_attrs => {
                title  => 'InnoDB Row Operations',
                vlabel => 'Operations per ${graph_period}',
                total  => 'Total',
            },
            data_source_attrs => {},
        },
        data_sources => [
            {name => 'Innodb_rows_deleted',  label => 'Deletes',
                                             info  => 'The number of rows deleted from InnoDB tables.'},
            {name => 'Innodb_rows_inserted', label => 'Inserts',
                                             info  => 'The number of rows inserted into InnoDB tables.'},
            {name => 'Innodb_rows_read',     label => 'Reads',
                                             info  => 'The number of rows read from InnoDB tables.'},
            {name => 'Innodb_rows_updated',  label => 'Updates',
                                             info  => 'The number of rows updated in InnoDB tables.'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    innodb_semaphores => {
        config => {
            global_attrs => {
                title  => 'InnoDB Semaphores',
                vlabel => 'Semaphores per ${graph_period}',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'ib_spin_rounds', label => 'Spin Rounds'},
            {name => 'ib_spin_waits',  label => 'Spin Waits'},
            {name => 'ib_os_waits',    label => 'OS Waits'},
        ],
    },
    
    #---------------------------------------------------------------------
    
    innodb_tnx => {
        config => {
            global_attrs => {
                title  => 'InnoDB Transactions',
                vlabel => 'Transactions per ${graph_period}',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'ib_tnx', label => 'Transactions created',
                               info  => 'Number of transactions created.'},
        ],
    },
}}

1;

