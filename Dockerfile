# Wir nutzen PHP 8.2 mit Apache als Basis
FROM php:8.2-apache

# 1. System-Abhängigkeiten für PostgreSQL installieren
RUN apt-get update && apt-get install -y \
    libpq-dev \
    && docker-php-ext-install pdo pdo_pgsql

# 2. Apache Rewrite Module aktivieren (wichtig für unser Routing)
RUN a2enmod rewrite

# 3. DocumentRoot auf /public umstellen (Sicherheit!)
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 4. Arbeitsverzeichnis setzen
WORKDIR /var/www/html

# 5. Dateien kopieren
COPY . .

# 6. Berechtigungen setzen (optional, falls Bilder-Uploads geplant sind)
RUN chown -R www-data:www-data /var/www/html