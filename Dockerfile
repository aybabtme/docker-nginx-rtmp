FROM ubuntu:18.04
ARG NGINX_RTMP_VERSION
RUN mkdir -p /tmp/workdir && \
    cd /tmp/workdir && \
    apt-get -y update && \
    apt-get -y install software-properties-common dpkg-dev git ffmpeg && \
    add-apt-repository -y ppa:nginx/stable && \
    sed -i '/^#.* deb-src /s/^#//' /etc/apt/sources.list.d/nginx-ubuntu-stable-bionic.list && \
    apt-get -y update && \
    apt-get -y source nginx && \
    cd $(find . -maxdepth 1 -type d -name "nginx*") && \
    git clone https://github.com/arut/nginx-rtmp-module.git && \
    cd nginx-rtmp-module && \
    git checkout $NGINX_RTMP_VERSION && \
    sed -i "s|common_configure_flags := \\\|common_configure_flags := \\\--add-module=$(cd  nginx-rtmp-module && pwd) \\\|" debian/rules && \
    apt-get -y build-dep nginx && \
    dpkg-buildpackage -b && \
    cd .. && \
    dpkg --install $(find . -maxdepth 1 -type f -name "nginx-common*") && \
    dpkg --install $(find . -maxdepth 1 -type f -name "libnginx*") && \
    dpkg --install $(find . -maxdepth 1 -type f -name "nginx-full*") && \
    mkdir -p /srv/www/ && \
    mkdir -p /tmp/hls && \
    mkdir -p /var/log/nginx && \
    cp nginx-1.16.1/nginx-rtmp-module/stat.xsl /srv/www/stat.xsl && \
    chown -R www-data /srv/www/ && \
    chown -R www-data /tmp/hls/ && \
    chown -R www-data /var/log/nginx && \
    if [ -f /etc/nginx/modules-enabled/50-mod-rtmp.conf ]; then rm /etc/nginx/modules-enabled/50-mod-rtmp.conf; fi && \
    rm -r /tmp/workdir
CMD [ "/usr/sbin/nginx", "-g", "daemon off; error_log stderr;" ]