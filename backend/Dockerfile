FROM python:alpine
WORKDIR /srv

# Install requirements
COPY requirements.txt ./
RUN \
# Install development tools
    apk add --no-cache mariadb-connector-c ca-certificates \
    && apk add --no-cache --virtual .dev-deps clang g++ linux-headers mariadb-connector-c-dev \
    && addgroup -g 1001 -S site \
    && adduser -u 1001 -S site -G site \
    && mkdir /var/run/site \
    && chown -R site:site /var/run/site \
    && chown -R site:site /srv \
    && pip install -U --no-cache-dir -r requirements.txt \
# Cleanup
    && apk del .dev-deps \
    && rm -rf /tmp/* /var/cache/apk/*

USER site
ENTRYPOINT ["gunicorn", "--bind", "unix:/var/run/site/site.sock", "--umask", "0", "--workers", "5", "buscatcher.asgi:application", "-k", "uvicorn.workers.UvicornWorker"]