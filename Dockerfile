ARG VERSION
FROM ruby:${VERSION}

WORKDIR /workspace
RUN mkdir -p lib/clusterid
COPY Gemfile Gemfile.lock clusterid.gemspec ./
COPY lib/clusterid/version.rb ./lib/clusterid/
RUN gem install bundler:2.3.3 && bundle install
