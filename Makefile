TARGET_PATH = ./dist
PRD_SERVER_HOST = root@115.29.211.120
UAT_SERVER_HOST = root@120.55.101.128

main:
	gulp --minify

prototype:
	BUILD_TARGET=prototype gulp

uat:
	BUILD_TARGET=uat gulp

deploy-prd-idc:
	-rm -fr $(TARGET_PATH)/static/coverage
	cd $(TARGET_PATH) && tar -czvf package.tar.gz static
	scp $(TARGET_PATH)/package.tar.gz $(PRD_SERVER_HOST):package.tar.gz
	-rm $(TARGET_PATH)/package.tar.gz
	ssh -t $(PRD_SERVER_HOST) "tar -xzvf package.tar.gz && cp -R static /usr/h5/nginx/html && rm -R static package.tar.gz"

deploy-uat-idc:
	-rm -fr $(TARGET_PATH)/static/coverage
	cd $(TARGET_PATH) && tar -czvf package.tar.gz static
	scp $(TARGET_PATH)/package.tar.gz $(UAT_SERVER_HOST):package.tar.gz
	-rm $(TARGET_PATH)/package.tar.gz
	ssh -t $(UAT_SERVER_HOST) "tar -xzvf package.tar.gz && cp -R static /usr/h5/nginx/html && rm -R static package.tar.gz"

deploy-prd-cdn:
	qrsync qiniu-prd.json

.PHONY: main prototype deploy