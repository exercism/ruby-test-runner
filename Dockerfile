FROM ruby:2.5-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

RUN gem install bundler -v "2.0.2"

WORKDIR /opt/test-runner

COPY . .

RUN bundle install

ENTRYPOINT [ "sh", "/opt/test-runner/bin/run.sh" ]