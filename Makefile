DOCKER_IMAGE := elecciones:2019
DOCKER_RUN := docker run -ti --rm -v ${PWD}/resultados:/opt/resultados

.DEFAULT: extraer-datos

all: setup construir-imagen extraer-datos

setup:
	rm -fr resultados || true
	mkdir -p resultados

construir-imagen:
	docker build . -f docker/Dockerfile -t $(DOCKER_IMAGE)

extraer-datos: construir-imagen
	$(DOCKER_RUN) $(DOCKER_IMAGE)

.PHONY: setup \
	construir-imagen \
	extraer-datos
