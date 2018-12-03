FROM ruby:2.5.1
MAINTAINER Adrian Perez <adrian@adrianperez.org>
COPY . /usr/src/app
VOLUME /usr/src/app
EXPOSE 4567

WORKDIR /usr/src/app


# RUN sed -i "s/httpredir.debian.org/mirrors.tuna.tsinghua.edu.cn/" /etc/apt/sources.list
# RUN apt-get clean
# RUN apt-get update && apt-get install -y nodejs \
# && rm -rf /var/lib/apt/lists/*
RUN bundle install

CMD ["bundle", "exec", "middleman", "server", "--watcher-force-polling"]
