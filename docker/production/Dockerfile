FROM ruby:2.7.4-alpine

ARG WORKDIR

ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo
ENV RAILS_ENV production
ENV BUNDLE_WITHOUT development:test

WORKDIR ${HOME}
COPY Gemfile* ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache -t .build-dependencies \
    alpine-sdk \
    build-base \
 && apk add --no-cache \
    bash \
    mysql-dev \
    tzdata \
    nginx \
    openrc \
 && gem install bundler:2.0.2 \
 && bundle install -j4 \
 && apk del --purge .build-dependencies && \
 rm -rf /usr/local/bundle/cache/* \
  /usr/local/share/.cache/* \
  /var/cache/* \
  /tmp/* \
  /usr/lib/mysqld* \
  /usr/bin/mysql*

COPY . ./

# nginx
ADD docker/production/nginx.conf /etc/nginx/nginx.conf
ADD docker/production/entrypoint.sh /app/entrypoint.sh

# openrc preparation
# ref: https://stackoverflow.com/questions/65627946
RUN openrc && touch /run/openrc/softlevel

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
# :chmod +x すべてのユーザーに実行権限を与える,
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

ADD . ${HOME}
EXPOSE 8080
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "8080", "-e", "production"]