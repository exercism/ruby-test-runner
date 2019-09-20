FROM ruby:2.7-rc-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

RUN mkdir /opt/test-runner
COPY . /opt/test-runner
WORKDIR /opt/test-runner
RUN bundle install
