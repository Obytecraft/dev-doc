FROM ruby:2.5.1
MAINTAINER Adrian Perez <adrian@adrianperez.org>
COPY . /usr/src/app
VOLUME /usr/src/app
EXPOSE 4567

WORKDIR /usr/src/app

# RUN npm config set proxy ${HTTP_PROXY}
# RUN npm config set proxy ${HTTPS_PROXY}
RUN pkg install node
# RUN apt-get update && apt-get install -y nodejs \
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
RUN bundle install

CMD ["bundle", "exec", "middleman", "server", "--watcher-force-polling"]
