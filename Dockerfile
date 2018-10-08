FROM ruby:2.5.1

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --system && apt-get update && apt-get install -y postgresql-contrib

ADD . /app
RUN bundle install --system


ADD createExtension.sh /docker-entrypoint-initdb.d/
RUN chmod 755 /docker-entrypoint-initdb.d/createExtension.sh


EXPOSE 4567

CMD ["ruby", "api.rb", "-p", "4567", "-o", "0.0.0.0"]

