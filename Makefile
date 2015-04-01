TARGET_PATH = ./dist
SERVER_HOST = root@115.29.211.120
LAST_CHANGED_REV = $(shell svn info | grep 'Last Changed Rev:' | cut -c19-)
LAST_CHANGED_DATE = $(shell svn info | grep 'Last Changed Date:' | cut -c20-)
WHO_AM_I = $(shell whoami)

main:
	gulp --properties "{\"deployedBy\": \"$(WHO_AM_I)\", \"lastChangedRev\": \"$(LAST_CHANGED_REV)\", \"lastChangedDate\": \"$(LAST_CHANGED_DATE)\"}"

prototype:
	BUILD_TARGET=prototype gulp --properties "{\"deployedBy\": \"$(WHO_AM_I)\", \"lastChangedRev\": \"$(LAST_CHANGED_REV)\", \"lastChangedDate\": \"$(LAST_CHANGED_DATE)\"}"

deploy:
	-rm -fr $(TARGET_PATH)/static/coverage
	cd $(TARGET_PATH) && tar -czvf package.tar.gz static
	scp $(TARGET_PATH)/package.tar.gz $(SERVER_HOST):package.tar.gz
	-rm $(TARGET_PATH)/package.tar.gz
	ssh -t $(SERVER_HOST) "tar -xzvf package.tar.gz && cp -R static /var/www/html && rm -R static package.tar.gz"

.PHONY: main prototype deploy