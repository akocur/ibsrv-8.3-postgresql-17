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
    && rm -rf /distributions

# Добавление ibsrv и ibcmd в PATH
RUN ln -s /opt/1cv8/x86_64/*/ibsrv /usr/local/bin/ibsrv \
    && ln -s /opt/1cv8/x86_64/*/ibcmd /usr/local/bin/ibcmd

WORKDIR /ibservers
RUN mkdir -p main/data with-data/data
RUN mkdir -p /src /dt/main /bin/main /configs/main

# Переключение на пользователя postgres для запуска сервисов
USER postgres

EXPOSE 1540-1559 8080-8084 8282-8286 8314-8318
