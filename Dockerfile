FROM ruby:2.5-alpine AS dev-induction
WORKDIR /usr/src/app
ENV RAILS_ENV production

EXPOSE 4567

ENV http_proxy "http://proxy-internet-aws-china-production.subsidia.org:3128"
ENV http_proxy "http://proxy-internet-aws-china-production.subsidia.org:3128"


RUN apk update && apk --update add ruby ruby-irb nodejs ruby-json ruby-rake \
    ruby-bigdecimal ruby-io-console libstdc++ tzdata libffi-dev libxml2-dev libxslt-dev 

RUN apk add --virtual build-deps git build-base ruby-dev \
    libc-dev linux-headers && \
    gem install bundler --no-ri --no-rdoc && \
    bundle config build.nokogiri --use-system-libraries

COPY Gemfile* /usr/src/app/
#COPY source dest
RUN bundle install --clean --without development test 

COPY . /usr/src/app
RUN bundle exec middleman build --verbose

FROM nginx:alpine
COPY --from=dev-induction /usr/src/app/build /usr/share/nginx/html 

# VOLUME /usr/src/app


# RUN apt-get update && apt-get install -y nodejs \
# && apt-get clean && rm -rf /var/lib/apt/lists/*
# RUN bundle install

# CMD ["bundle", "exec", "middleman", "server", "--watcher-force-polling"]
