FROM barquin/docker:ruby2_passenger_node_nginx 
MAINTAINER Venka Ashtakala "vashtakala@barquin.com"

EXPOSE 80

# Environment variables.
ENV HOME /root
ENV SECRET_KEY_BASE 73af2ea4ffdd52dc73e0cfb8b29dbc30b29f8d8e6938be3971b3e89ab05221466488b8f21ab879002f619520f1b8820fb6dfc36074cfda03b5d0acd73e05cc42
ENV RAILS_ENV production

##Rails application setup
RUN mkdir -p /home/rails/webapp
ADD . /home/rails/webapp
WORKDIR /home/rails/webapp
RUN bundle install --local
RUN ./setup.sh

# Start Nginx / Passenger
RUN rm -f /etc/service/nginx/down
CMD ["service","nginx","start"] && ["tail","-f","/opt/nginx/logs/errors.log"]


