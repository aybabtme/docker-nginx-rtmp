FROM ubuntu:18.04
ARG NGINX_RTMP_VERSION
RUN mkdir -p /tmp/workdir
ADD in_docker.sh /tmp/workdir/in_docker.sh
RUN cd /tmp/workdir && NGINX_RTMP_VERSION=${NGINX_RTMP_VERSION} /tmp/workdir/in_docker.sh && rm -r /tmp/workdir
CMD [ "/usr/sbin/nginx", "-g", "daemon off; error_log stderr;" ]