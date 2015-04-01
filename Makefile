TARGET_PATH = ./dist
SERVER_HOST = root@115.29.211.120

main:
	gulp

prototype:
	BUILD_TARGET=prototype gulp

deploy:
	-rm -fr $(TARGET_PATH)/static/coverage
	cd $(TARGET_PATH) && tar -czvf package.tar.gz static
	scp $(TARGET_PATH)/package.tar.gz $(SERVER_HOST):package.tar.gz
	-rm $(TARGET_PATH)/package.tar.gz
	ssh -t $(SERVER_HOST) "tar -xzvf package.tar.gz && cp -R static /var/www/html && rm -R static package.tar.gz"

.PHONY: main prototype deploy