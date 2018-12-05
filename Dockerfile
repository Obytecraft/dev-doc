FROM ruby:2.5.1
MAINTAINER Adrian Perez <adrian@adrianperez.org>
COPY . /usr/src/app
VOLUME /usr/src/app
EXPOSE 4567

WORKDIR /usr/src/app

ENV http_proxy "http://proxy-internet-aws-china-production.subsidia.org:3128"
ENV http_proxy "http://proxy-internet-aws-china-production.subsidia.org:3128"

RUN apt-get update && apt-get install -y nodejs \
&& apt-get clean && rm -rf /var/lib/apt/lists/*
RUN bundle install

CMD ["bundle", "exec", "middleman", "serve", "--bind-address 0.0.0.0", "--watcher-force-polling"]
