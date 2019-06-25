#!/usr/bin/env sh

set -e

pwd

echo "Preparando ambiente..."
gem install bundler
bundle install --path vendor

case $1 in
    todo)
        bundle exec rake 'importar[/opt/resultados]'
        ;;
    *)
        exec "$@"
        ;;
esac
