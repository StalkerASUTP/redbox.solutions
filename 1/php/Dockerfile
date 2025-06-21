FROM php:8.2-fpm-alpine

# Установка системных зависимостей
RUN apk add --no-cache \
    postgresql-dev \
    libpq \
    && docker-php-ext-install pdo pdo_pgsql

# Установка Redis расширения через PECL
RUN apk add --no-cache --virtual .build-deps \
    $PHPIZE_DEPS \
    && pecl install redis \
    && docker-php-ext-enable redis \
    && apk del .build-deps

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Настройка рабочей директории
WORKDIR /var/www

# Копирование composer.json и установка зависимостей
COPY composer.json ./
RUN composer install --no-dev --optimize-autoloader

# Копирование php.ini
RUN cp "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Создание пользователя для безопасности
RUN addgroup -g 1000 -S www && \
    adduser -u 1000 -S www -G www

# Изменение владельца директории
RUN chown -R www:www /var/www

USER www

EXPOSE 9000

CMD ["php-fpm"]