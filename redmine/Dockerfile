FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ca-certificates wget \
    postgresql ruby ruby-dev git \
    make zlib1g-dev libxml2-dev libpq-dev pkg-config \
    imagemagick libmagickcore-dev libmagickwand-dev

RUN gem install bundler

RUN mkdir /usr/share/redmine \
    && cd /usr/share/redmine \
    && git clone https://github.com/redmine/redmine.git . \
    && git checkout 3.1.1

# Avant, nécessaire pour l'installation de Redmine via bundle
ADD database.yml /usr/share/redmine/config/

RUN cd /usr/share/redmine \
    && bundle install --without development test

ENV RAILS_ENV=production

RUN cd /usr/share/redmine \
    && rake generate_secret_token

USER postgres

RUN /etc/init.d/postgresql start \
    && psql --command "CREATE USER redmine WITH SUPERUSER PASSWORD 'password';" \
    && createdb -O redmine redmine

USER root

RUN /etc/init.d/postgresql start \
    && cd /usr/share/redmine \
    && rake db:migrate \
    && REDMINE_LANG=fr rake redmine:load_default_data

ADD ./run.sh /usr/bin/

CMD ["run.sh"]
