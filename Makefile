### Configuration

CONFIG_DIR:=/etc/munin
PLUGIN_DIR:=/usr/local/share/munin/plugins
MUNIN_NODE:=/etc/init.d/munin-node
PERL_SITELIB_DIR:=$(shell perl '-V:installsitelib'|cut -d"'" -f2)

# Instance numbers, space separated. Leave empty if you only want to
# monitor one instance.
INSTANCES:=""

GRAPHS:=$(shell find lib -name '*.pm')
# Uncomment the following line if you also want to install all the
# contributed graphs:
# GRAPHS:=$(shell find lib contrib -name '*.pm')

### Don't edit below this line

-include local.mk

.PHONY: all test install test_diff_ok

all: 
	@echo $(GRAPHS)

install:
	mkdir -p $(PLUGIN_DIR)
	install mysql $(PLUGIN_DIR)

	if [ ! -e $(CONFIG_DIR)/plugin-conf.d/mysql.conf ]; then \
          install mysql.conf $(CONFIG_DIR)/plugin-conf.d; \
        fi
	if [ $(INSTANCES) = "" ]; then \
          ln -sf $(PLUGIN_DIR)/mysql $(CONFIG_DIR)/plugins/mysql; \
        else \
	  INSTANCES=$(INSTANCES); \
          for I in $$INSTANCES; do \
            ln -sf $(PLUGIN_DIR)/mysql $(CONFIG_DIR)/plugins/mysql_$${I}; \
          done; \
        fi

	install -d $(PERL_SITELIB_DIR)/Munin/MySQL/Graph
	install $(GRAPHS) $(PERL_SITELIB_DIR)/Munin/MySQL/Graph

	$(MUNIN_NODE) restart

test:
	prove t

test_diff_ok:
	TEST_REGRESSION_GEN=1 prove t/regression.t

