FROM dwiagus/phalcon:rdkafka
ENV EXT_RDKAFKA_VERSION=4.0.3
ENV LIBRDKAFKA_VERSION=1.4.0
ENV BUILD_DEPS 'autoconf git gcc g++ make bash openssh'

RUN apk --no-cache upgrade \
    && apk add $BUILD_DEPS

RUN git clone --depth 1 --branch v$LIBRDKAFKA_VERSION https://github.com/edenhill/librdkafka.git /tmp/librdkafka/ \
    && cd /tmp/librdkafka \
    && ./configure \
    && make \
    && make install \
    && rm -rf /tmp/librdkafka


RUN pecl channel-update pecl.php.net \
    && pecl install rdkafka-$EXT_RDKAFKA_VERSION \
    && docker-php-ext-enable rdkafka \
    && rm -rf /librdkafka \
    && apk del $BUILD_DEPS