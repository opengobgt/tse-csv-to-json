DOCKER_IMAGE := elecciones:2019
DOCKER_RUN := docker run --rm -v ${PWD}/resultados:/ruby/resultados

.DEFAULT: extraer-datos

construir-imagen:
	docker build . -f Dockerfile -t $(DOCKER_IMAGE)

extraer-datos: construir-imagen
	$(DOCKER_RUN) $(DOCKER_IMAGE)

.PHONY: construir-imagen \
		extraer-datos