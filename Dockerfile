FROM ruby:3.02-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

RUN wget -P /usr/local/bin https://github.com/exercism/tooling-webserver/releases/latest/download/tooling_webserver && \
    chmod +x /usr/local/bin/tooling_webserver

WORKDIR /opt/test-runner

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.1.4 && \
    bundle config set without 'development test' && \
    bundle install

COPY . .

ENTRYPOINT [ "sh", "/opt/test-runner/bin/run.sh" ]
