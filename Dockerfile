FROM ruby:2.0
MAINTAINER Venka Ashtakala "vashtakala@barquin.com"

EXPOSE 80
EXPOSE 3000

# Environment variables.
ENV HOME /root


#Package installations
RUN apt-get update -y
#RUN adduser --disabled-password --home=/home/rails --gecos "" rails
#RUN usermod -g sudo rails

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
ADD config/nginx/etc/nginx/sites-available/default /etc/nginx/sites-available/default

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down
#RUN service nginx start

# Clean up APT when done.
CMD apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
