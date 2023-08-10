FROM ruby:3.0.2-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

WORKDIR /opt/test-runner

COPY Gemfile Gemfile.lock ./
RUN gem install bundler:2.2.29 && \
    bundle config set without 'development test' && \
    bundle install

COPY . .

ENTRYPOINT [ "sh", "/opt/test-runner/bin/run.sh" ]
