# === 1 ===
# Setup
FROM ruby:2.0
MAINTAINER Venka Ashtakala "vashtakala@barquin.com"

# Set correct environment variables.
ENV HOME /root

CMD apt-get install -y nginx

# === 2 ===
# Remove the default site
CMD rm /etc/nginx/sites-available/default

# Add the nginx info
ADD config/nginx/etc/nginx/sites-available/default /etc/nginx/sites-available/default

# === 3 ===
# Start Nginx / Passenger
CMD service nginx start

# === 4 ===
# Load puma config files
ADD config/puma/etc/init/* /etc/init/
ADD config/puma/etc/* /etc/

# === 5 ===
# Prepare folders
RUN mkdir /root/webapp

# === 6 ===
# Run Bundle in a cache efficient way
WORKDIR /tmp
ADD Gemfile /tmp/
ADD Gemfile.lock /tmp/
CMD bundle install

# === 7 ===
# Add the rails app
ADD . /root/webapp

# === 8 ===
# Start rails app
CMD restart puma-manager

# Clean up APT when done.
CMD apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
