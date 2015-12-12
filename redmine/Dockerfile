FROM pgentile/debian
MAINTAINER Pierre Gentile <pierre.gentile.perso@gmail.com>

RUN apt-get install -y ca-certificates wget \
    postgresql-client \
    ruby ruby-dev git \
    make zlib1g-dev libxml2-dev libpq-dev pkg-config \
    imagemagick libmagickcore-dev libmagickwand-dev

RUN gem install bundler

ENV RAILS_ENV=production \
    REDMINE_VERSION=3.2.0 \
    REDMINE_LANG=fr

RUN mkdir /usr/share/redmine \
    && cd /usr/share/redmine \
    && git clone --branch $REDMINE_VERSION --depth 1 https://github.com/redmine/redmine.git .

# Avant, nécessaire pour l'installation de Redmine via bundle
ADD conf/database.yml /usr/share/redmine/config/

RUN cd /usr/share/redmine \
    && bundle install --without development test

RUN cd /usr/share/redmine \
    && rake generate_secret_token

ADD ./run.sh ./install.sh /usr/bin/

CMD ["run.sh"]
