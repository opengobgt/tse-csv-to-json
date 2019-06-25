# tse-csv-to-json

Transforma la data en CSV presentada por el TSE en documentos json

## Instalacion

Para hacer uso de este script es necesario instalar Ruby 2.6 y Git

Es recomendado usar RVM para instalar Ruby https://rvm.io/rvm/install

## Uso


Clona este repositorio

```
mkdir ~/OpenGobGt
cd ~/OpenGobGt
git clone git@github.com:opengobgt/tse-csv-to-json.git
```

Si no quieres instalar herramientas en tu sistema local usa las instrucciones de [docker](##Docker)

Instala las dependencias

```
cd ~/OpenGobGt/tse-csv-to-json
gem install bundler
bundle install
```

Desde el diretorio raiz ejectuta:
```
cd ~/OpenGobGt/tse-csv-to-json

$ rake importar
```

## Docker

Para obtener los resultados en formato json asegurate que tienes Docker instalado en tu sistema y
ejecuta los siguientes comandos

```
cd ~/OpenGobGt/tse-csv-to-json
make all
```

Esto empezara con el proceso de extracción de los resultados para convertirlos en formato json.

El proceso toma unos minutos, los resultados los encontraras en el folder [resultados](/resultados)

Si solo deseas construir la imagen de `Docker` usa el siguiente comando

```
make construir-imagen
```

Puedes ejecutar manualmente la extracción de datos con el siguiente comando

```
docker run --ti --rm -v /directorio/local:/ruby/resultados elecciones:2019
```
