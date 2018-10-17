FROM ruby:2.5.1

WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN bundle install --system && apt-get update && apt-get install -y postgresql-contrib

ADD . /app
RUN bundle install --system





EXPOSE 4567
ENV POSTGRES_DB gatekeeper
ENV POSTGRES_PASSWORD tango
ENV POSTGRES_USER tangodefault
ENV DATABASE_HOST son-postgres
ENV DATABASE_PORT 5432
#ENV DATABASE_URL=postgresql://tangodefault:tango@son-postgres:5432/gatekeeper
ENV MQSERVER_URL=amqp://guest:guest@son-broker:5672
ENV CATALOGUE_URL=http://tng-cat:4011/catalogues/api/v2
ENV REPOSITORY_URL=http://tng-rep:4012
ENV POLICY_MNGR_URL=http://tng-policy-mngr:8081/api/v1
ENV SLM_URL=http://tng-slice-mngr:5998/api
ENV SLICE_INSTANCE_CHANGE_CALLBACK_URL=http://tng-gtk-sp:5000/requests
ENV PORT 4567


#ADD createExtension.sh /docker-entrypoint-initdb.d/
#RUN chmod 755 /docker-entrypoint-initdb.d/createExtension.sh


CMD ["ruby", "api.rb", "-p", "4567", "-o", "0.0.0.0"]



#CMD ["ruby", "api.rb", "-p", "4567", "-o", "0.0.0.0", "rake", "db:migrate"]
#CMD ["sh","-c","rake db:migrate && ruby api.rb -p 4567 -o 0.0.0.0"]


#CMD ["bundle", "exec", "thin", "-p", "4567", "-D", "start"]


