FROM php:8.2-apache

# Install system packages required by Moodle
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    wget \
    libicu-dev \
    libxml2-dev \
    libxslt1-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libpq-dev \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Configure GD
RUN docker-php-ext-configure gd \
    --with-freetype \
    --with-jpeg

# Build PHP extensions
RUN docker-php-ext-install \
    mysqli \
    intl \
    gd \
    soap \
    zip \
    exif \
    xsl \
    opcache

# Install Redis
RUN pecl install redis \
    && docker-php-ext-enable redis

# Enable Apache rewrite
RUN a2enmod rewrite

WORKDIR /var/www/html
