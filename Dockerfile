FROM ruby:2.0
MAINTAINER Venka Ashtakala "vashtakala@barquin.com"

EXPOSE 80

# Environment variables.
ENV HOME /root


#Package installations
RUN apt-get update -y

#Rails application setup
RUN mkdir /root/webapp
ADD . /root/webapp
WORKDIR /root/webapp
RUN bundle install
RUN cd `bundle show passenger` \
    && bin/passenger-install-nginx-module

# Setup NGINX configuration
RUN rm /etc/nginx/sites-available/default
ADD config/nginx/etc/nginx/sites-available/default /etc/nginx/sites-available/default

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down
RUN service nginx start

# Clean up APT when done.
CMD apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
