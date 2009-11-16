### Configuration

CONFIG_DIR:=/etc/munin
PLUGIN_DIR:=/usr/local/share/munin/plugins
MUNIN_NODE:=/etc/init.d/munin-node

### Don't edit below this line

.PHONY: all test links clean install

all: 

test: mysql_
	@ echo testing ...
	@ > test/values.out~
	@ > test/config.out~
	@ for CMD in `find . -maxdepth 1 -name 'mysql_?*' -and -type l | sort`; do \
          perl -Itest/mock $$CMD >> test/values.out~; \
          perl -Itest/mock $$CMD config >> test/config.out~; \
        done 
	diff -q test/values.out test/values.out~ || true
	diff -q test/config.out test/config.out~ || true
	@ echo ---------------------------------------------------------
	@ prove test


links: mysql_
	./mysql_ suggest | while read X; do ln -sf mysql_ mysql_$$X; done

install:
	mkdir -p $(PLUGIN_DIR)
	install mysql_ $(PLUGIN_DIR)
	install mysql_.conf $(CONFIG_DIR)/plugin-conf.d
	./mysql_ suggest | while read X; do \
          ln -sf $(PLUGIN_DIR)/mysql_ $(CONFIG_DIR)/plugins/mysql_$$X; \
        done
	$(MUNIN_NODE) restart


clean:
	rm -f test/values.out~ test/config.out~
	find . -maxdepth 1 -name 'mysql_?*' -and -type l -exec rm {} \;

