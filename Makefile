### Configuration

CONFIG_DIR:=/etc/munin
PLUGIN_DIR:=/usr/local/share/munin/plugins
MUNIN_NODE:=/etc/init.d/munin-node

# Instance numbers, space separated. Leave empty if you only want to
# monitor one instance.
INSTANCES:=""

### Don't edit below this line

-include local.mk

.PHONY: all test clean install show_test_diff test_diff_ok

all: 

install:
	mkdir -p $(PLUGIN_DIR)
	install mysql $(PLUGIN_DIR)

	if [ ! -e $(CONFIG_DIR)/plugin-conf.d/mysql.conf ]; then \
          install mysql.conf $(CONFIG_DIR)/plugin-conf.d; \
        fi; \
	if [ $(INSTANCES) = "" ]; then \
          ln -sf $(PLUGIN_DIR)/mysql $(CONFIG_DIR)/plugins/mysql; \
        else \
	  INSTANCES=$(INSTANCES); \
          for I in $$INSTANCES; do \
            echo $$I; \
            ln -sf $(PLUGIN_DIR)/mysql $(CONFIG_DIR)/plugins/mysql_$${I}; \
          done; \
        fi

	$(MUNIN_NODE) restart

clean:
	rm -f test/values.out~ test/config.out~

test:
	@ export MUNIN_CAP_MULTIGRAPH=1 ; \
	  perl -Ilib -Itest/mock mysql > test/values.out~; \
          perl -Ilib -Itest/mock mysql config > test/config.out~; \
          diff -q test/values.out test/values.out~ && echo 'values .. ok'; \
          diff -q test/config.out test/config.out~ && echo 'config .. ok'; \
          echo '---' ; \
	  prove test 2>&1 | grep -v 'Output from SHOW ENGINE INNDOB STATUS was truncated'

show_test_diff:
	diff test/values.out test/values.out~ | less;
	diff test/config.out test/config.out~ | less;

test_diff_ok:
	cp test/values.out~ test/values.out
	cp test/config.out~ test/config.out


