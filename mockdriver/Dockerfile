FROM python:alpine
WORKDIR /srv
ENV PROJ_DIR=/usr \
    PROJ_LIBDIR=/usr/lib \
    PROJ_INCDIR=/usr/include

# Install requirements
COPY requirements.txt ./
RUN \
# Install development tools
    apk add --no-cache proj proj-util \
    && apk add --no-cache --virtual .dev-deps clang g++ linux-headers proj-dev \
    && addgroup -g 1001 -S site \
    && adduser -u 1001 -S site -G site \
    && chown -R site:site /srv \
    && pip install -U --no-cache-dir -r requirements.txt \
# Cleanup
    && apk del .dev-deps \
    && rm -rf /tmp/* /var/cache/apk/*

USER site
ENTRYPOINT ["python3", "-OO", "app.py"]