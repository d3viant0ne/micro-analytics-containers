FROM nginx:latest

MAINTAINER Webpack

VOLUME /var/cache/nginx

# Copy nginx configs
COPY ./config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./config/nginx/proxy.conf /etc/nginx/proxy.conf
COPY ./config/nginx/micro-analytics-upstream.conf /etc/nginx/micro-analytics-upstream.conf
COPY ./config/nginx/micro-analytics-servername.conf /etc/nginx/micro-analytics-servername.conf

# Copy localhost ssl certs
COPY ./.ssl/server.crt    /etc/nginx/cert/server.crt
COPY ./.ssl/server.key /etc/nginx/cert/server.key

EXPOSE 80 443

ENTRYPOINT ["nginx"]
CMD ["-g", "daemon off;"]