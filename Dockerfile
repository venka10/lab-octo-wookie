FROM barquin/docker:ruby2_passenger_node_nginx 
MAINTAINER Venka Ashtakala "vashtakala@barquin.com"

EXPOSE 80

##Rails application setup
USER rails
RUN mkdir -p /home/rails/webapp
ADD . /home/rails/webapp
WORKDIR /home/rails/webapp
RUN bundle install --local
RUN ./setup.sh

# Start Nginx / Passenger
USER root
RUN rm -f /etc/service/nginx/down
CMD /usr/sbin/service nginx start; tail -f /opt/nginx/logs/access.log


