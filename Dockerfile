FROM ruby:3.1.2

WORKDIR /app
COPY . /app

RUN gem install rackup
RUN bundle install

EXPOSE 3000

CMD ["rackup"]
