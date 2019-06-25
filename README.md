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

Clona el directorio de datos

```
cd ~/OpenGobGt/
git clone git@github.com:opengobgt/tse-datos-primera-vuelta-2019.git
```

Desde el diretorio raiz ejectuta cualquiera de los Rake tasks
incluidos.

```
cd ~/OpenGobGt/tse-csv-to-json

$ rake -vT
rake importar_corporacion_municipal[archivo,directorio]                        # Importar archivo de corporacion municipal
rake importar_corporaciones_municipales[directorio_fuente,directorio_destino]  # Importar corporaciones municipales
rake importar_diputado_distrital[archivo,directorio]                           # Importar archivo de diputado distrital
rake importar_diputados_distritales[directorio_fuente,directorio_destino]      # Importar diputados distritales
rake importar_listado_nacional[archivo,directorio]                             # Importar archivo de diputados por listado nacional
rake importar_parlamento_centroamericano[archivo,directorio]                   # Importar archivo de parlamento centroamericano
rake importar_presidente_y_vicepresidente[archivo,directorio]                  # Importar archivo de presidente y vicepresidente
```

Ejemplos:

```
cd ~/OpenGobGt/tse-csv-to-json

rake 'importar_corporaciones_municipales[~/OpenGobGt/tse-datos-primera-vuelta-2019/resultados/corporacion_municipal]'

rake 'importar_diputados_distritales[~/OpenGobGt/tse-datos-primera-vuelta-2019/resultados/diputados_distritales]'

rake 'importar_listado_nacional[~/OpenGobGt/tse-datos-primera-vuelta-2019/resultados/DIPUTADOS_POR_LISTA_NACIONAL_NACIONAL.txt]'
```

## Docker

Para obtener los resultados en formato json asegurate que tienes Docker instalado en tu sistema y
ejecuta los siguientes comandos

```
cd ~/OpenGobGt/tse-csv-to-json
make extraer-datos
```

Esto empezara con el proceso de extracción de los resultados para convertirlos en formato json.

El proceso toma unos minutos, los resultados los encontraras en el folder [resultados](/resultados)

Si solo deseas construir la imagen de `Docker` usa el siguiente comando

```
make construir-imagen
```

Puedes ejecutar manualmente la extracción de datos con el siguiente comando

```
docker run --rm -v /directorio/local:/ruby/resultados elecciones:2019
```

También puedes extraer solo de cierto tipo de de resultados

- municipales
- distritales
- nacionales
- parlacen
- presidenciables

Ejemplo:

```
docker run --rm -v /directorio/local:/ruby/resultados elecciones:2019 presidenciables
```
