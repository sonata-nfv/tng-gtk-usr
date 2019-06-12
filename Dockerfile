FROM ruby:2.4.3

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN printf "deb http://archive.debian.org/debian/ jessie main\ndeb-src http://archive.debian.org/debian/ jessie main\ndeb http://security.debian.org jessie/updates main\ndeb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list
RUN apt-get update && apt-get install -y postgresql-contrib

ADD . /app
RUN bundle install --system

EXPOSE 4567
ENV POSTGRES_DB gatekeeper
ENV POSTGRES_PASSWORD tango
ENV POSTGRES_USER tangodefault
ENV DATABASE_HOST son-postgres
ENV DATABASE_PORT 5432
ENV SLICE_INSTANCE_CHANGE_CALLBACK_URL=http://tng-gtk-sp:5000/requests
ENV PORT 4567

CMD ["ruby", "api.rb", "-p", "4567", "-o", "0.0.0.0"]



