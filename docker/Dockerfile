FROM ruby:alpine
RUN apk add --update git alpine-sdk
COPY . /opt/src
WORKDIR /opt/src
VOLUME [ "/opt/resultados" ]
ENTRYPOINT [ "/opt/src/docker/entrypoint.sh" ]
CMD [ "todo" ]
