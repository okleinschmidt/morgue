#
# make it so
#

PHPUNIT:=phpunit --include-path=phplib --log-junit results.xml
VERSION := $(shell git rev-parse --short HEAD)

# targets

all: deploy_version

include mk/Makefile.php
_MKVENDOR_php_CONFIGURE_FLAGS+= --with-pdo-mysql

build: php deploy_version config/bazooka.json

# just symlink to /tmp - the run.sh script fulfills promise this at startup
config/bazooka.json:
	ln -s /tmp/morgue.json $@

deploy_version:
	@echo "Setting MORGUE_VERSION to $(VERSION) in phplib/deploy_version.php..."
	@sed 's/{{ VERSION }}/$(VERSION)/' <phplib/deploy_version.php.in >phplib/deploy_version.php

unittests:
	${PHPUNIT} tests/unit/

# You can use this to set up basic structure of a new feature like so:
# make feature NAME=report
feature:
	@if [ -d features/$(NAME) ]; then \
		echo "Feature \"$(NAME)\" already exists";\
		exit 1;\
	fi
	@echo "making new feature " $(NAME)
	@mkdir -p features/$(NAME)/views
	@touch features/$(NAME)/lib.php
	@cp skeleton/feature_routes.php features/$(NAME)/routes.php
	@perl -p -i -e 's/%%FEATURE%%/$(NAME)/g' features/$(NAME)/routes.php
	@touch features/$(NAME)/views/$(NAME).php
	@echo "THIS IS THE $(NAME) VIEW" > features/$(NAME)/views/$(NAME).php
	@echo "Feature directory for $(NAME) created."
	@echo "Remember to add an entry to your feature config."
