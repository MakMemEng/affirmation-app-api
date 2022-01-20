FROM ruby:2.7.4-alpine

ARG WORKDIR
ARG RUNTIME_PACKAGES="nodejs tzdata mysql-client mysql-dev git"
ARG DEV_PACKAGES="build-base curl-dev"

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

WORKDIR ${HOME}

COPY Gemfile* ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4 && \
    apk del build-dependencies && \
    rm -rf /usr/local/bundle/cache/* \
    /usr/local/share/.cache/* \
    /var/cache/* \
    /tmp/* \
    /usr/lib/mysqld* \
    /usr/bin/mysql*

COPY . ./

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
# :chmod +x すべてのユーザーに実行権限を与える,
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

ADD . ${HOME}
EXPOSE 8080
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "8080", "-e", "production"]
