FROM ruby:4.0.10-alpine3.24@sha256:9d3416708d4f434a62bf265a865deab75d376cc1d260c71651c9fb8708dbb2e7 AS build

RUN apk update && apk upgrade && \
    apk add --no-cache git openssh build-base gcc wget git

COPY .ruby-version Gemfile Gemfile.lock ./

RUN gem install bundler:4.0.11 && \
    bundle config set without 'development test' && \
    bundle install

FROM ruby:4.0.10-alpine3.24@sha256:9d3416708d4f434a62bf265a865deab75d376cc1d260c71651c9fb8708dbb2e7 AS runtime

RUN apk add --no-cache bash

COPY --from=build /usr/local/bundle /usr/local/bundle

WORKDIR /opt/test-runner

COPY . .

ENTRYPOINT [ "sh", "/opt/test-runner/bin/run.sh" ]
