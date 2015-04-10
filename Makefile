TARGET_PATH = ./dist
IDC_SERVER_HOST = root@115.29.211.120

main:
	gulp

prototype:
	BUILD_TARGET=prototype gulp

deploy-idc:
	-rm -fr $(TARGET_PATH)/idc/static/coverage
	cd $(TARGET_PATH)/idc && tar -czvf package.tar.gz static
	scp $(TARGET_PATH)/idc/package.tar.gz $(IDC_SERVER_HOST):package.tar.gz
	-rm $(TARGET_PATH)/idc/package.tar.gz
	ssh -t $(IDC_SERVER_HOST) "tar -xzvf package.tar.gz && cp -R static /var/www/html && rm -R static package.tar.gz"

.PHONY: main prototype deploy