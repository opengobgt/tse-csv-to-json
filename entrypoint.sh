#!/usr/bin/env sh

function coorporaciones_municipales () {
    echo "Extrayendo datos para coorporaciones municipales..."
    rake 'importar_corporaciones_municipales[/ruby/datos/resultados/corporacion_municipal]'
}

function diputados_distritales () {
    echo "Extrayendo datos para diputados distritales..."
    rake 'importar_diputados_distritales[/ruby/datos/resultados/diputados_distritales]'
}

function diputados_nacionales () {
    echo "Extrayendo datos para diputados por lista nacional..."
    rake 'importar_listado_nacional[/ruby/datos/resultados/DIPUTADOS_POR_LISTA_NACIONAL_NACIONAL.txt]'
}

function diputados_parlacen () {
    echo "Extrayendo datos para diputados al parlacen..."
    rake 'importar_parlamento_centroamericano[/ruby/datos/resultados/DIPUTADOS_AL_PARLAMENTO_CENTROAMERICANO_NACIONAL.txt]'
}

function presidenciables () {
    echo "Extrayendo datos para presidente y vicepresidente..."
    rake 'importar_presidente_y_vicepresidente[/ruby/datos/resultados/PRESIDENTE_Y_VICEPRESIDENTE_NACIONAL.txt]'
}

echo "Clonando repositorio de datos..."
git clone https://github.com/opengobgt/tse-datos-primera-vuelta-2019.git datos
echo "Preparando ambiente..."
gem install bundler
bundle install

case $1 in
    todo)
        coorporaciones_municipales;
        diputados_distritales;
        diputados_nacionales;
        diputados_parlacen;
        presidenciables;
        ;;
    municipales)
        coorporaciones_municipales        
        ;;
    distritales)
        diputados_distritales        
        ;;
    nacionales)
        diputados_nacionales        
        ;;
    parlacen)
        diputados_parlacen        
        ;;
    presidenciables)
        presidenciables        
        ;;
    *)
    echo parametro no válido $1
    ;;
esac

