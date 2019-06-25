FROM ruby:alpine
RUN apk add git
COPY . /ruby/
WORKDIR /ruby
VOLUME [ "/ruby/resultados" ]
ENTRYPOINT [ "/ruby/entrypoint.sh" ]
CMD [ "todo" ]