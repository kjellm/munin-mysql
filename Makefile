VERSION=$(shell grep -A2 '=head1 VERSION' mysql_ | tail -n1)
PACKAGE=munin-mysql_$(VERSION)

.PHONY: all test links clean bundle

all: mysql_ README


README: mysql_
	perldoc -t mysql_ > README

test: mysql_
	> test/values.out~
	> test/config.out~
	for CMD in `find . -maxdepth 1 -name 'mysql_?*' -and -type l | sort`; do \
          perl -Itest/mock $$CMD >> test/values.out~; \
          perl -Itest/mock $$CMD config >> test/config.out~; \
        done 
	diff -q test/values.out test/values.out~ || true
	diff -q test/config.out test/config.out~ || true
	prove test


links: mysql_
	./mysql_ suggest | while read X; do ln -s mysql_ $$X; done


clean:
	rm -f test/values.out~ test/config.out~ README
	find . -maxdepth 1 -name 'mysql_?*' -and -type l -exec rm {} \;
	rm -rf $(PACKAGE) $(PACKAGE).tar.bz2


bundle: all COPYING
	mkdir -p $(PACKAGE)
	cp mysql_ README COPYING $(PACKAGE)
	tar cjf $(PACKAGE).tar.bz2 $(PACKAGE)
