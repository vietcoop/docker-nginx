FROM nginx:1.14.2-alpine AS build_modules

RUN \
    get_latest_release() { \
        wget -qO- "https://api.github.com/repos/$1/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'; \
    } \
    && apk update \
    && apk add curl wget \
    && apk add curl-dev protobuf-dev pcre-dev openssl-dev msgpack-c-dev \
    && apk add build-base cmake autoconf automake git linux-headers gd-dev geoip-dev libxml2-dev libxslt-dev openssl-dev paxmark pcre-dev pkgconf zlib-dev \
    && cd ~ \
    && cd ~ \
    && git clone -b release-1.14.2 https://github.com/nginx/nginx.git \
    && cd $HOME/nginx \
        && auto/configure \
            --prefix=/var/lib/nginx \
            --sbin-path=/usr/sbin/nginx \
            --modules-path=/usr/lib/nginx/modules \
            --conf-path=/etc/nginx/nginx.conf \
            --pid-path=/run/nginx/nginx.pid --lock-path=/run/nginx/nginx.lock --http-client-body-temp-path=/var/tmp/nginx/client_body \
            --http-proxy-temp-path=/var/tmp/nginx/proxy \
            --http-fastcgi-temp-path=/var/tmp/nginx/fastcgi \
            --http-uwsgi-temp-path=/var/tmp/nginx/uwsgi \
            --http-scgi-temp-path=/var/tmp/nginx/scgi \
            --user=nginx --group=nginx --with-threads \
            --with-file-aio \
            --with-http_ssl_module \
            --with-http_v2_module \
            --with-http_realip_module \
            --with-http_addition_module \
            --with-http_xslt_module=dynamic \
            --with-http_geoip_module=dynamic \
            --with-http_sub_module \
            --with-http_gunzip_module --with-http_gzip_static_module \
            --with-http_auth_request_module \
            --with-http_random_index_module \
            --with-http_secure_link_module \
            --with-http_slice_module \
            --with-http_stub_status_module \
            --with-stream_ssl_module \
            --with-stream_realip_module --with-stream_geoip_module=dynamic --with-stream_ssl_preread_module \
    && make modules \
    && ls -l objs \
    && echo Made \
    && ls -l /usr/local/lib \
    && ls -l $HOME/nginx/objs
