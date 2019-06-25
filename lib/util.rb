# frozen_string_literal: true

require 'json'
require 'fileutils'
require 'csv'
require 'deep_merge'
require 'ruby-progressbar'

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

def cargar_archivo(archivo, progreso = false)
  # abrir archivo fuente
  mesas = CSV.read(archivo, col_sep: "\t", headers: true)
  p = ProgressBar.create(total: mesas.size) if progreso
  mesas.each do |mesa|
    yield(mesa)
    p.increment if progreso
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

def importar_archivo(archivo, directorio, tipo_eleccion, progreso = false)
  Dir.mkdir(directorio) unless File.directory?(directorio)

  cargar_archivo(archivo, progreso) do |registro_mesa|
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
    File.open(archivo_mesa, 'w') do |f|
      f.write(mesa.to_json)
    end
  end
end
