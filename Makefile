all: app.js static_data.js
	cd web-customer; make
	cd web-merchant; make

%.js: %.coffee
	coffee -cb $<

deploy:
	./scripts/deploy.sh

watch:
	watch -n 1 make

run: all
	vertx run app.js

static:
	vertx run static_data.js

.PHONY: watch run static