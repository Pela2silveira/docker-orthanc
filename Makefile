include *.env

configure:
	@echo "generating Orthanc configuration..."
	@mkdir -p conf
	@sed \
		-e 's/<orthanc-name>/${ORTHANC_NAME}/g' \
		-e 's/<aet>/${AE_TITLE}/g' \
		-e 's/<orthanc-user>/${ORTHANC_USER}/g' \
		-e 's/<orthanc-password>/${ORTHANC_PASSWORD}/g' \
		-e 's/<orthanc-viewer-user>/${ORTHANC_VIEWER_USER}/g' \
		-e 's/<orthanc-viewer-password>/${ORTHANC_VIEWER_PASSWORD}/g' \
		templates/orthanc.json.template > conf/orthanc.json
	@if [ ! -f conf/modalities.json ]; then \
		cp templates/modalities.json.template conf/modalities.json; \
		echo "created conf/modalities.json — edit modalities before first run"; \
	else \
		echo "keeping existing conf/modalities.json"; \
	fi
	@sed 's/<admin-user>/${ORTHANC_USER}/g' templates/http-filter.lua.template > conf/http-filter.lua
	@echo "done."

prepare_storage:
	sudo mkdir -p /var/local/orthanc/db

run: configure
	@test -d /var/local/orthanc/db || (echo "run: make prepare_storage"; exit 1)
	docker compose -p orthanc up -d

stop:
	docker compose -p orthanc stop

start:
	docker compose -p orthanc start

restart: stop start

delete:
	docker compose -p orthanc down
	@echo "deleting configuration files..."
	rm -f conf/orthanc.json conf/modalities.json conf/http-filter.lua

delete_all: delete
	@echo "this will delete all Orthanc storage under /var/local/orthanc..."
	sudo rm -rf /var/local/orthanc

log:
	docker logs -f orthanc

shell:
	docker exec -it orthanc bash

all: prepare_storage run
