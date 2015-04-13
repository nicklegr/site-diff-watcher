FROM ruby:2.2.1

RUN echo "Asia/Tokyo" > /etc/timezone
RUN dpkg-reconfigure -f noninteractive tzdata

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# ONBUILD --
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --jobs 4

COPY . /usr/src/app
# ONBUILD --

EXPOSE 80
CMD bash run.sh
