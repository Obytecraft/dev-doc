FROM ruby:2.5.1
MAINTAINER Adrian Perez <adrian@adrianperez.org>
COPY . /usr/src/app
VOLUME /usr/src/app
EXPOSE 4567

WORKDIR /usr/src/app


RUN echo "LC_ALL=en_US.UTF-8" >> /etc/environment
RUN echo "LANG=en_US.UTF-8" >> /etc/environment
RUN echo "NODE_ENV=development" >> /etc/environment
RUN more "/etc/environment"
#RUN locale-gen en_US en_US.UTF-8
#RUN dpkg-reconfigure locales


RUN apt-get clean
RUN sed -i "s/httpredir.debian.org/mirrors.tuna.tsinghua.edu.cn/" /etc/apt/sources.list
RUN apt-get -y update 
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash
RUN apt-get install --yes nodejs
RUN node -v
RUN npm -v
RUN npm i -g nodemon
RUN nodemon -v

# Cleanup
# RUN apt-get update && apt-get upgrade -y && apt-get autoremove -y
RUN bundle install

CMD ["bundle", "exec", "middleman", "server", "--watcher-force-polling"]
