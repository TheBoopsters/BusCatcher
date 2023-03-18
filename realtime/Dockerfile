FROM python:alpine
WORKDIR /srv

# Install requirements
COPY requirements.txt ./
RUN \
# Install development tools
    apk add --no-cache --virtual .dev-deps clang g++ linux-headers \
    && addgroup -g 1001 -S site \
    && adduser -u 1001 -S site -G site \
    && chown -R site:site /srv \
    && pip install -U --no-cache-dir -r requirements.txt \
# Cleanup
    && apk del .dev-deps \
    && rm -rf /tmp/* /var/cache/apk/*

USER site
ENTRYPOINT ["python3", "-OO", "app.py"]