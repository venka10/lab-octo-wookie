FROM ruby:2.0
MAINTAINER Venka Ashtakala "vashtakala@barquin.com"

EXPOSE 80
EXPOSE 3000

# Environment variables.
ENV HOME /root
ENV SECRET_KEY_BASE 73af2ea4ffdd52dc73e0cfb8b29dbc30b29f8d8e6938be3971b3e89ab05221466488b8f21ab879002f619520f1b8820fb6dfc36074cfda03b5d0acd73e05cc42
ENV RAILS_ENV development 
#production

#Package installations
RUN apt-get update -y
RUN apt-get install -y vim
#RUN adduser --disabled-password --home=/home/rails --gecos "" rails
#RUN usermod -g sudo rails

RUN curl -sL https://deb.nodesource.com/setup_0.12 | bash -
RUN apt-get install -y nodejs

#Rails application setup
#USER rails
RUN mkdir -p /home/rails/webapp
ADD . /home/rails/webapp
WORKDIR /home/rails/webapp
RUN bundle install --local
RUN cd `bundle show passenger` \
    && bin/passenger-install-nginx-module
RUN ./setup.sh

# Setup NGINX configuration
#UN rm /etc/nginx/sites-available/default
ADD config/docker/nginx/opt/nginx/conf/nginx.conf /opt/nginx/conf/nginx.conf
ADD config/docker/nginx/etc/init.d/nginx /etc/init.d/nginx

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down
RUN service nginx start

# Clean up APT when done.
CMD apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
