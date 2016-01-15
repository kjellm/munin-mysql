package Munin::MySQL::Graph::CacheEfficiency;

# Author <mrten+munin@ii.nl>
#
# This one isnt in mysql-cacti-templates, show the efficiency of some
# mysql caches.  They're all momentary snapshots, made by having
# RRDtool calculate the derive of the graphed variables, and then
# dividing up those derives. This prevents the uselessness of the
# variables after a couple of weeks uptime (the calculated hitrate
# would be the average over the uptime of the server, which is hardly
# interesting).
#
# The graph_order is used to work around a bug in munin regarding
# cdef, see
# http://sourceforge.net/mailarchive/message.php?msg_id=26897601
#
# * key_cache   : the MyISAM key cache efficiency, straigt from the mysql manual,
#                 talked down by some but slightly more useful now
# * query_cache : the query cache efficiency
# * binlog_cache: inspired by a post seen on planet mysql:
#                 http://www.chriscalender.com/?p=154

sub graphs { return {
    caches => {
        config => {
            global_attrs => {
                title  => 'Cache efficiency',
                vlabel => '%',
                order => 'krd=Key_reads krrd=Key_read_requests qh=Qcache_hits cs=Com_select bcdu=Binlog_cache_disk_use bcu=Binlog_cache_use key_cache_eff qcache_eff bl_cache_eff',
            },
            data_source_attrs => {
                draw  => 'LINE1',
                type  => 'GAUGE',
            },
        },
        data_sources => [
            {name => 'Key_reads',             graph  => 'no', type  => 'DERIVE', label => 'Key_reads'},
            {name => 'krd',                   graph  => 'no', label => 'krd'},
            {name => 'Key_read_requests',     graph  => 'no', type  => 'DERIVE', label => 'Key_read_requests'},
            {name => 'krrd',                  graph  => 'no', label => 'krrd'},
            {name => 'key_cache_eff',         label  => 'Momentary key cache efficiency',
                                              update => 'no',
                                              # this should check for krrd==0
                                              cdef   => '1,krd,krrd,/,-,100,*'},
            {name => 'Qcache_hits',           graph  => 'no', type  => 'DERIVE', label => 'Qcache_hits'},
            {name => 'qh',                    graph  => 'no', label => 'qh'},
            {name => 'Com_select',            graph  => 'no', type  => 'DERIVE', label => 'Com_select'},
            {name => 'cs',                    graph  => 'no', label => 'cs'},
            {name => 'qcache_eff',            label  => 'Momentary query cache efficiency',
                                              update => 'no',
                                              info   => '',
                                              cdef   => 'Qcache_hits,qh,cs,+,/,100,*'
                                              },
            # MySQL 5.5.9: binlog_stmt_cache_size ipv binlog_cache_size
            {name => 'Binlog_cache_disk_use', graph  => 'no', type  => 'DERIVE', label => 'Binlog_cache_disk_use'},
            {name => 'bcdu',                  graph  => 'no', label => 'bcdu'},
            {name => 'Binlog_cache_use',      graph  => 'no', type  => 'DERIVE', label => 'Binlog_cache_use'},
            {name => 'bcu',                   graph  => 'no', label => 'bcu'},
            {name => 'bl_cache_eff',          label  => 'Momentary binlog cache efficiency',
                                              update => 'no',
                                              info   => 'Tune binlog_cache_size or change replication to ROW or MIXED if problematic',
                                              cdef   => '1,bcdu,bcu,/,-,100,*'},
        ],
    },
}}

1;
