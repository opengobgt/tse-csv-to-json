# frozen_string_literal: true

require 'json'
require 'fileutils'
require 'csv'
require 'pp'
require 'deep_merge'

MESA = {
  mesa: 0,
  departamento: 0,
  municipio: 0,
  actas: {}
}.freeze

VOTOS = {
  validos_acta: 0,
  validos: 0,
  nulos: 0,
  blancos: 0,
  invalidos: 0,
  total_acta: 0,
  total_votos: 0,
  acta_cuadra: 0,
  impugnaciones: 0,
  partidos: []
}.freeze

ACTA = {
  tipo_eleccion: 0,
  estado_acta: 0,
  cantidad_papeletas: 0,
  votos: {}
}.freeze

HEADERS = %w[MESA
             TIPO_ELECCION
             DEPTO
             MUNI
             ESTADO_ACTA
             CANTIDAD_PAPELETAS
             VOTOS_VALIDOS_ACTA
             VOTOS_VALIDOS
             NULOS BLANCOS
             INVALIDOS
             TOTAL_ACTA
             TOTAL_VOTOS
             ACTA_CUADRA
             IMPUGNACIONES].freeze

HEADER = {
  mesa: 'MESA',
  tipo_eleccion: 'TIPO_ELECCION',
  departamento: 'DEPTO',
  municipio: 'MUNI',
  estado_acta: 'ESTADO_ACTA',
  cantidad_papeletas: 'CANTIDAD_PAPELETAS',
  validos_acta: 'VOTOS_VALIDOS_ACTA',
  validos: 'VOTOS_VALIDOS',
  nulos: 'NULOS',
  blancos: 'BLANCOS',
  invalidos: 'INVALIDOS',
  total_acta: 'TOTAL_ACTA',
  total_votos: 'TOTAL_VOTOS',
  acta_cuadra: 'ACTA_CUADRA',
  impugnaciones: 'IMPUGNACIONES'
}.freeze

def cargar_campos(registro_mesa, mesa, keys)
  keys.each do |key|
    cargar_campo(registro_mesa, mesa, key)
  end
end

def cargar_campo(registro_mesa, mesa, key)
  mesa[key] = registro_mesa[HEADER[key]].to_i
end

def cargar_archivo(archivo)
  # abrir archivo fuente
  registros_mesas = CSV.read(archivo, col_sep: "\t", headers: true)
  registros_mesas.each do |registro_mesa|
    yield(registro_mesa)
  end
end

def extraer_partidos(registro_mesa)
  partidos = []
  registro_mesa.headers.each do |header|
    next if header =~ /^V\d+/

    partidos << header unless HEADERS.include?(header)
  end
  partidos
end

def importar_archivo(archivo, directorio, tipo_eleccion)
  Dir.mkdir(directorio) unless File.directory?(directorio)

  cargar_archivo(archivo) do |registro_mesa|
    mesa = MESA.dup
    cargar_campos(registro_mesa, mesa, %i[mesa departamento municipio])

    acta = ACTA.dup
    cargar_campos(registro_mesa, acta, %i[tipo_eleccion estado_acta cantidad_papeletas])

    votos = VOTOS.dup
    cargar_campos(registro_mesa, votos, %i[validos_acta validos nulos blancos invalidos total_acta total_votos acta_cuadra impugnaciones])

    desglose = []
    partidos = extraer_partidos(registro_mesa)
    partidos.each do |partido|
      desglose << { partido => registro_mesa[partido].to_i }
    end

    votos[:desglose] = desglose
    acta[:votos] = votos
    mesa[:actas][tipo_eleccion] = acta

    # crear o abir archivo de mesa
    archivo_mesa = File.join(directorio, "mesa_#{mesa[:mesa]}.json")
    if File.exist?(archivo_mesa)
      data = JSON.parse(File.read(archivo_mesa))
      mesa = JSON.parse(mesa.to_json).deep_merge(data)
    end
    pp mesa
    File.open(archivo_mesa, 'w') do |f|
      f.write(mesa.to_json)
    end
    puts ''
  end
end

task default: %w[usage]

task :usage do
  puts 'Para ver mas opciones digite:'
  puts '  rake -vT'
end

desc 'Limpia el directorio de resultados'
task :clean do
  FileUtils.rm_rf('resultados')
end

desc 'Prepara el ambiente de desarrollo'
task :setup do
  Rake::Task[:clean].invoke
  FileUtils.mkdir('resultados')
end

desc 'Importar diputados distritales'
task :importar_diputados_distritales, [:directorio_fuente, :directorio_destino] do |_t, args|
  fuente = args[:directorio_fuente]
  destino = (args[:directorio_destino] ||= 'resultados')
  raise "Directorio #{fuente} no exite." unless File.directory?(fuente)
  raise "Directorio #{destino} no exite." unless File.directory?(destino)

  archivos = Dir["#{fuente}/*.txt"].sort
  puts archivos
  archivos.each do |archivo|
    Rake::Task[:importar_diputado_distrital].reenable
    Rake::Task[:importar_diputado_distrital].invoke(archivo, destino)
  end
end

desc 'Importar archivo de diputado distrital'
task :importar_diputado_distrital, [:archivo, :directorio] do |_t, args|
  archivo = args[:archivo]
  directorio = (args[:directorio] ||= 'resultados')
  raise "Parametro 'archivo' es requerido." if archivo.nil?
  raise "Archivo #{archivo} no encontrado." unless File.exist?(archivo)

  importar_archivo(archivo, directorio, :diputados_distritales)
end

desc 'Importar corporaciones municipales'
task :importar_corporaciones_municipales, [:directorio_fuente, :directorio_destino] do |_t, args|
  fuente = args[:directorio_fuente]
  destino = (args[:directorio_destino] ||= 'resultados')
  raise "Directorio #{fuente} no exite." unless File.directory?(fuente)
  raise "Directorio #{destino} no exite." unless File.directory?(destino)

  archivos = Dir["#{fuente}/*.txt"].sort
  puts archivos
  archivos.each do |archivo|
    Rake::Task[:importar_corporacion_municipal].reenable
    Rake::Task[:importar_corporacion_municipal].invoke(archivo, destino)
  end
end

desc 'Importar archivo de corporacion municipal'
task :importar_corporacion_municipal, [:archivo, :directorio] do |_t, args|
  archivo = args[:archivo]
  directorio = (args[:directorio] ||= 'resultados')
  raise "Parametro 'archivo' es requerido." if archivo.nil?
  raise "Archivo #{archivo} no encontrado." unless File.exist?(archivo)

  importar_archivo(archivo, directorio, :corporacion_municipal)
end

desc 'Importar archivo de parlamento centroamericano'
task :importar_parlamento_centroamericano, [:archivo, :directorio] do |_t, args|
  archivo = args[:archivo]
  directorio = (args[:directorio] ||= 'resultados')
  raise "Parametro 'archivo' es requerido." if archivo.nil?
  raise "Archivo #{archivo} no encontrado." unless File.exist?(archivo)

  importar_archivo(archivo, directorio, :parlamento_centroamericano)
end

desc 'Importar archivo de parlamento centroamericano'
task :importar_parlamento_centroamericano, [:archivo, :directorio] do |_t, args|
  archivo = args[:archivo]
  directorio = (args[:directorio] ||= 'resultados')
  raise "Parametro 'archivo' es requerido." if archivo.nil?
  raise "Archivo #{archivo} no encontrado." unless File.exist?(archivo)

  importar_archivo(archivo, directorio, :parlamento_centroamericano)
end


desc 'Importar archivo de diputados por listado nacional'
task :importar_listado_nacional, [:archivo, :directorio] do |_t, args|
  archivo = args[:archivo]
  directorio = (args[:directorio] ||= 'resultados')
  raise "Parametro 'archivo' es requerido." if archivo.nil?
  raise "Archivo #{archivo} no encontrado." unless File.exist?(archivo)

  importar_archivo(archivo, directorio, :diputados_listado_nacional)
end

desc 'Importar archivo de presidente y vicepresidente'
task :importar_presidente_y_vicepresidente, [:archivo, :directorio] do |_t, args|
  archivo = args[:archivo]
  directorio = (args[:directorio] ||= 'resultados')
  raise "Parametro 'archivo' es requerido." if archivo.nil?
  raise "Archivo #{archivo} no encontrado." unless File.exist?(archivo)

  importar_archivo(archivo, directorio, :presidente_y_vicepresidente)
end
