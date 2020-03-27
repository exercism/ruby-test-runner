FROM ruby:2.5-alpine

RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh && \
    apk add build-base gcc wget git

RUN gem install bundler -v "2.0.2"

RUN mkdir /opt/test-runner
COPY . /opt/test-runner
WORKDIR /opt/test-runner
RUN bundle install

ENTRYPOINT [ "sh", "bin/run.sh" ]