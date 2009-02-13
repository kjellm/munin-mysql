VERSION=0.1
PACKAGE=munin-mysql_$(VERSION)

.PHONY: all test links clean build

all: mysql_ README


README: mysql_.in
	perldoc mysql_ > README
	perl -pi -e 's/A~Xierud/Øierud/' README

mysql_: mysql_.in
	perl -pe 's/\@\@PERL\@\@/\/usr\/bin\/perl/' mysql_.in > mysql_
	chmod a+x mysql_


test: mysql_
	> values.out~
	> config.out~
	for CMD in `find . -maxdepth 1 -name 'mysql_?*' -and -type l | sort`; do \
          perl -Imock $$CMD >> values.out~; \
          perl -Imock $$CMD config >> config.out~; \
        done 
	diff -q values.out values.out~ || true
	diff -q config.out config.out~ || true


links: mysql_
	./mysql_ suggest | while read X; do ln -s mysql_ $$X; done


clean:
	rm -f values.out~ config.out~ README mysql_
	find . -maxdepth 1 -name 'mysql_?*' -and -type l -exec rm {} \;
	rm -rf $(PACKAGE) $(PACKAGE).tar.bz2


bundle: all
	mkdir -p $(PACKAGE)
	cp mysql_ README $(PACKAGE)
	tar cjf $(PACKAGE).tar.bz2 $(PACKAGE)
