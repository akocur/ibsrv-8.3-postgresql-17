FROM akocur/postgresql-1c-17:latest

USER root

# Установка необходимых пакетов для 1С
RUN echo "deb http://deb.debian.org/debian bookworm contrib" >> /etc/apt/sources.list \
    && apt-get update && apt-get install -y \
    libmagickwand-dev \
    libfontconfig1 \
    libfreetype6 \
    libgsf-1-common\
    libglib2.0-0 \
    libodbc1 \
    libkrb5-3 \
    libgssapi-krb5-2 \
    ttf-mscorefonts-installer \
    && fc-cache -fv \
    && rm -rf /var/lib/apt/lists/*

# Копирование пакетов 1С в контейнер
WORKDIR /distributions
COPY ./distributions/1c-enterprise-8.3*-common_8.3*.deb .
COPY ./distributions/1c-enterprise-8.3*-server_8.3*.deb .
COPY ./distributions/1c-enterprise-8.3*-ws_8.3*.deb .

# Установка сервера 1С
RUN dpkg -i 1c-enterprise-8.3*-common_8.3*.deb \
    && dpkg -i 1c-enterprise-8.3*-server_8.3*.deb \
    && dpkg -i 1c-enterprise-8.3*-ws_8.3*.deb \
    && rm -rf /tmp/distributions

WORKDIR /ibservers/main-branch

RUN mkdir -p /src /dt/main-branch /cf/main-branch /configs/main-branch

EXPOSE 1540-1541 1560-1591 8080 8282 8314

# Запуск сервисов при старте контейнера
CMD ["/start.sh"]
