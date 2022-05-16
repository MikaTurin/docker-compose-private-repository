FROM alpine:3.14

ARG REPOSITORY_DOMAIN=github.com
# Private repositories also works if private key is ~/.ssh/id_rsa on your machine
ARG REPOSITORY_URL=git@github.com:PHP-DI/demo.git
# Also change document root in nginx.conf

# PHP8 also can be used here
RUN apk add --no-cache \
  openssh-client \
  git \
  curl \
  nginx \
  php7 \
  php7-cli \
  php7-json \
  php7-ctype \
  php7-curl \
  php7-fpm \
  php7-mbstring \
  php7-opcache \
  php7-openssl \
  php7-phar \
#  php7-dom \
#  php7-gd \
#  php7-intl \
#  php7-mysqli \
#  php7-session \
#  php7-xml \
#  php7-xmlreader \
#  php7-zlib \
  supervisor

# Create symlink for php8
#RUN ln -s /usr/bin/php8 /usr/bin/php

# Copy configs
COPY config/nginx.conf /etc/nginx/nginx.conf
#COPY config/fpm7-pool.conf /etc/php7/php-fpm.d/www.conf
COPY config/php.ini /etc/php7/conf.d/custom.ini
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Make sure files/folders needed by the processes are accessable when they run under the nobody user
RUN mkdir -p /var/www/app
RUN chown -R nobody.nobody /var/www/app /run /var/lib/nginx /var/log/nginx /var/log/php7

# Add application
#COPY --chown=nobody src/ /var/www/app/

# Download public key for github.com
RUN mkdir -p -m 0700 ~/.ssh && ssh-keyscan ${REPOSITORY_DOMAIN} >> ~/.ssh/known_hosts

# Clone private repository
RUN --mount=type=ssh git clone ${REPOSITORY_URL} /var/www/app/
WORKDIR /var/www/app
RUN wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet && php composer.phar install

# Switch to use a non-root user from here on
USER nobody

# Expose the port nginx is reachable on
EXPOSE 80

# Let supervisord start nginx & php-fpm
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]