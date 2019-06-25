# frozen_string_literal: true

Dir.glob('lib/*.rb').each { |r| load r }

REPOSITORIO_DATOS = 'https://github.com/opengobgt/tse-datos-primera-vuelta-2019.git'
DIR_RESULTADOS = 'resultados'
DIR_REPO_DATOS = '/tmp/datos'
DIR_DATOS = "#{DIR_REPO_DATOS}/resultados"
DIR_CORP_MUNICIPAL = "#{DIR_DATOS}/corporacion_municipal"
DIR_DIP_DISTRITALES = "#{DIR_DATOS}/diputados_distritales"
FILE_DIP_NACIONAL = "#{DIR_DATOS}/DIPUTADOS_POR_LISTA_NACIONAL_NACIONAL.txt"
FILE_PARLACEN = "#{DIR_DATOS}/DIPUTADOS_AL_PARLAMENTO_CENTROAMERICANO_NACIONAL.txt"
FILE_PRESIDENTE = "#{DIR_DATOS}/PRESIDENTE_Y_VICEPRESIDENTE_NACIONAL.txt"

task default: %w[importar]

desc 'Limpia el directorio de resultados'
task :clean, [:directorio_resultados] do |_t, args|
  directorio_destino = (args[:directorio_destino] ||= DIR_RESULTADOS)

  puts '[INFO] Limpiando directorios'
  FileUtils.rm_rf(directorio_destino)
  FileUtils.rm_rf('/tmp/datos')
end

desc 'Prepara el ambiente de desarrollo'
task :setup do
  Rake::Task[:clean].invoke
  puts "[INFO] Descargando repositorio #{REPOSITORIO_DATOS}"
  FileUtils.mkdir('resultados')
  `git clone --depth=1 #{REPOSITORIO_DATOS} #{DIR_REPO_DATOS}`
end

desc 'Importar directorio'
task :importar_directorio, [:tipo_datos, :directorio_fuente, :directorio_destino] do |_t, args|
  tipo_datos = args[:tipo_datos].to_sym
  fuente = args[:directorio_fuente]
  destino = (args[:directorio_destino] ||= DIR_RESULTADOS)
  raise "Directorio #{fuente} no exite." unless File.directory?(fuente)
  raise "Directorio #{destino} no exite." unless File.directory?(destino)

  archivos = Dir["#{fuente}/*.txt"].sort

  puts "[INFO] Importando directorio #{fuente}"
  pb = ProgressBar.create(total: archivos.size)
  archivos.each do |archivo|
    Rake::Task[:importar_archivo].reenable
    Rake::Task[:importar_archivo].invoke(tipo_datos, archivo, destino)
    pb.increment
  end
end

desc 'Importar archivo'
task :importar_archivo, [:tipo_datos, :archivo_fuente, :directorio_destino, :progreso] do |_t, args|
  datos = args[:tipo_datos].to_sym
  archivo = args[:archivo_fuente]
  destino = (args[:directorio_destino] ||= DIR_RESULTADOS)
  progreso = (args[:progreso] ||= false)
  raise "Parametro 'archivo' es requerido." if archivo.nil?
  raise "Archivo #{archivo} no encontrado." unless File.exist?(archivo)

  importar_archivo(archivo, destino, datos, progreso)
end

task :importar, [:directorio_destino] do |_t, args|
  directorio_destino = (args[:directorio_destino] ||= DIR_RESULTADOS)

  Rake::Task[:setup].invoke

  Rake::Task[:importar_directorio].reenable
  Rake::Task[:importar_directorio].invoke(:corporaciones_municipales, DIR_CORP_MUNICIPAL, directorio_destino)

  Rake::Task[:importar_directorio].reenable
  Rake::Task[:importar_directorio].invoke(:diputados_distritales, DIR_DIP_DISTRITALES, directorio_destino)

  puts "[INFO] Importando archivo #{FILE_DIP_NACIONAL}"
  Rake::Task[:importar_archivo].reenable
  Rake::Task[:importar_archivo].invoke(:diputados_nacionales, FILE_DIP_NACIONAL, directorio_destino, true)

  puts "[INFO] Importando archivo #{FILE_PARLACEN}"
  Rake::Task[:importar_archivo].reenable
  Rake::Task[:importar_archivo].invoke(:diputados_parlacen, FILE_PARLACEN, directorio_destino, true)

  puts "[INFO] Importando archivo #{FILE_PRESIDENTE}"
  Rake::Task[:importar_archivo].reenable
  Rake::Task[:importar_archivo].invoke(:presidente, FILE_PRESIDENTE, directorio_destino, true)
end
