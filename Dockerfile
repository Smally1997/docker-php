FROM php:7.3

RUN apt-get update && apt-get install -y git unzip libzip-dev libcurl4-openssl-dev pkg-config libssl-dev libicu-dev sqlite libgmp-dev librabbitmq-dev libxml2-dev libpng-dev zlib1g-dev

# Install PECL and PEAR extensions
RUN pecl install xdebug

# Install and enable php extensions
RUN docker-php-ext-enable \
    xdebug
RUN docker-php-ext-configure zip --with-libzip
RUN docker-php-ext-install \
    curl \
    iconv \
    mbstring \
    pdo \
    pdo_mysql \
	soap \
	gd \
	intl \
	exif \
    pcntl \
    tokenizer \
    zip \
    bcmath

# Install composer
ENV COMPOSER_HOME /composer
ENV PATH ./vendor/bin:/composer/vendor/bin:$PATH
ENV COMPOSER_ALLOW_SUPERUSER 1
RUN curl -s https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin/ --filename=composer

# Install PHP_CodeSniffer
RUN composer global require "squizlabs/php_codesniffer=*"

# Setup working directory
WORKDIR /var/www