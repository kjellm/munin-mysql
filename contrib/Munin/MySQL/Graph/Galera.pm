package Munin::MySQL::Graph::Galera;

# Author <mrten+munin@ii.nl>
#
# This graphs about everything I could find for galera replication, including
# percona's cluster solution PXC.

use warnings;
use strict;

use POSIX qw(floor);

sub graphs { return {

    wsrep_cluster_size => {
        config => {
            global_attrs => {
                title  => 'Galera cluster size',
                vlabel => 'Hosts',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'wsrep_cluster_size', label => 'Cluster size',
                                           info  => 'The number of hosts in the cluster.',
                                           type  => 'GAUGE'},
        ],
    },

    #---------------------------------------------------------------------

    # wsrep_cluster_status is nice to have but a string

     wsrep_local_state => {
        config => {
            global_attrs => {
                title  => 'Galera node state',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'wsrep_local_state', label => '1-Joining, 2-Donor, 3-Joined, 4-Synced',
                                          info  => 'The state of the node in the cluster.',
                                          type  => 'GAUGE'},
        ],
    },

    #---------------------------------------------------------------------

     wsrep_transactions => {
        config => {
            global_attrs => {
                title  => 'Galera transactions',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'wsrep_last_committed', label => 'Committed transactions',
                                             info  => '# of committed transactions.',
                                             type  => 'COUNTER',
                                             min   => 0},
            {name => 'wsrep_local_commits',  label => 'Locally Committed transactions',
                                             info  => '# of locally committed transactions.',
                                             type  => 'COUNTER',
                                             min   => 0},
        ],
    },

    #---------------------------------------------------------------------

     wsrep_writesets => {
        config => {
            global_attrs => {
                title  => 'Galera writesets',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'wsrep_replicated', label => 'Writesets sent',
                                         info  => '# of writesets sent to other nodes',
                                         type  => 'COUNTER',
                                         min   => 0},
            {name => 'wsrep_received',   label => 'Writesets received',
                                         info  => '# of writesets received from other nodes',
                                         cdef  => 'wsrep_received,-1,*',
                                         type  => 'COUNTER',
                                         min   => 0},
        ],
    },

     wsrep_writesetbytes => {
        config => {
            global_attrs => {
                title  => 'Galera writesets bytes/sec',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'wsrep_replicated_bytes', label => 'Writesets bytes sent',
                                               info  => '# of bytes in writesets sent to other nodes',
                                               type  => 'DERIVE',
                                               min   => 0},
            {name => 'wsrep_received_bytes',   label => 'Writesets bytes received',
                                               info  => '# of bytes in writesets received from other nodes',
                                               cdef  => 'wsrep_received_bytes,-1,*',
                                               type  => 'DERIVE',
                                               min   => 0},
        ],
    },
     wsrep_avgwritesetbytes => {
        config => {
            global_attrs => {
                title  => 'Galera writesets average bytes',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'wsrep_replicated',       type  => 'DERIVE',
                                               graph => 'no',
                                               min   => 0},
            {name => 'wsrep_received',         type  => 'DERIVE',
                                               graph => 'no',
                                               min   => 0},
            {name => 'wsrep_replicated_bytes', type  => 'DERIVE',
                                               graph => 'no',
                                               min   => 0},
            {name => 'wsrep_received_bytes',   type  => 'DERIVE',
                                               graph => 'no',
                                               min   => 0},
            {name => 'wsrep_avgreplicated',    label => 'average size of sent writeset',
                                               cdef  => 'wsrep_replicated_bytes,wsrep_replicated,/'},
            {name => 'wsrep_avgreceived',      label => 'average size of received writeset',
                                               cdef  => 'wsrep_received_bytes,wsrep_received,/'},

        ],
    },

     wsrep_errors => {
        config => {
            global_attrs => {
                title  => 'Galera transaction problems'
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'wsrep_local_cert_failures', label => 'Certification failures',
                                                  type  => 'DERIVE',
                                                  min   => 0},
            {name => 'wsrep_local_bf_aborts',     label => 'Aborted local transactions',
                                                  type  => 'DERIVE',
                                                  min   => 0},
            {name => 'wsrep_local_replays',       label => 'Replays',
                                                  type  => 'DERIVE',
                                                  min   => 0},
        ],
    },


     wsrep_queue => {
        config => {
            global_attrs => {
                title  => 'Galera queues'
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'wsrep_local_send_queue',     label => 'Send queue length',
                                                   type  => 'GAUGE'},
            {name => 'wsrep_local_send_queue_avg', label => 'Average send queue length',
                                                   type  => 'GAUGE'},
            {name => 'wsrep_local_recv_queue',     label => 'Receive queue length',
                                                   type  => 'GAUGE'},
            {name => 'wsrep_local_recv_queue_avg', label => 'Average receive queue length',
                                                   type  => 'GAUGE'},
        ],
    },


     wsrep_flow => {
        config => {
            global_attrs => {
                title  => 'Galera flow control',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'wsrep_flow_control_paused',    label => 'Time flow control was paused',
                                                     type  => 'GAUGE'},
            {name => 'wsrep_flow_control_sent',      label => 'Pause events sent',
                                                     type  => 'GAUGE'},
            {name => 'wsrep_flow_control_recv',      label => 'Pause events received',
                                                     type  => 'GAUGE'},
        ],
    },


     wsrep_distance => {
        config => {
            global_attrs => {
                title  => 'Galera distance',
            },
            data_source_attrs => {
                draw  => 'LINE1',
            },
        },
        data_sources => [
            {name => 'wsrep_cert_deps_distance',    label => 'cert_deps_distance',
                                                    type  => 'GAUGE'},
            {name => 'wsrep_commit_window',         label => 'commit_window',
                                                    type  => 'GAUGE'},
        ],
    },



}}

1;

