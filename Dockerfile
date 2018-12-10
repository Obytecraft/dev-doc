FROM ruby:2.5.1

ENV http_proxy "http://proxy-internet-aws-china-production.subsidia.org:3128"
ENV http_proxy "http://proxy-internet-aws-china-production.subsidia.org:3128"

RUN apt-get update
RUN apt-get install -y software-properties-common
# RUN add-apt-repository -y ppa:nginx/stable

RUN apt-get -y install nginx

RUN mkdir /srv/www

ADD default /etc/nginx/sites-available/default
ADD nginx.conf /etc/nginx/nginx.conf

WORKDIR /srv/www

ADD . /srv/www/
RUN bundle install --without development test
RUN exec middleman build --verbose

EXPOSE 80

CMD nginx