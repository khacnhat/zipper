FROM  alpine:3.7
LABEL maintainer=jon@jaggersoft.com

# - - - - - - - - - - - - - - - - - -
# install ruby+
# tar is needed to tar-pipe test coverage out of tmpfs.
# git is needed for the service
# - - - - - - - - - - - - - - - - - -

RUN apk --update --no-cache add \
    bash \
    tar \
    git \
    ruby-bundler \
    ruby-dev

# - - - - - - - - - - - - - - - - - -
# install ruby gems
# - - - - - - - - - - - - - - - - - -

ARG                ZIPPER_HOME=/app
COPY    Gemfile  ${ZIPPER_HOME}/
WORKDIR          ${ZIPPER_HOME}

RUN apk --update add --virtual build-dependencies build-base \
  && bundle config --global silence_root_warning 1 \
  && bundle install \
  && apk del build-dependencies build-base \
  && rm -vrf /var/cache/apk/*

# - - - - - - - - - - - - - - - - - -
# copy source & set ownership
# - - - - - - - - - - - - - - - - - -

COPY . ${ZIPPER_HOME}
RUN  chown -R nobody:nogroup ${ZIPPER_HOME}
USER nobody

# - - - - - - - - - - - - - - - - - -
# bring it up
# - - - - - - - - - - - - - - - - - -

EXPOSE 4588
CMD [ "./up.sh" ]
