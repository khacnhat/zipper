ARG   ALPINE_VERSION
FROM  alpine:${ALPINE_VERSION}
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

ARG                CYBER_DOJO_HOME
COPY    Gemfile  ${CYBER_DOJO_HOME}/
WORKDIR          ${CYBER_DOJO_HOME}

RUN apk --update add --virtual build-dependencies build-base \
  && bundle config --global silence_root_warning 1 \
  && bundle install \
  && apk del build-dependencies build-base \
  && rm -vrf /var/cache/apk/*

# - - - - - - - - - - - - - - - - - -
# copy source & set ownership
# - - - - - - - - - - - - - - - - - -

COPY . ${CYBER_DOJO_HOME}
RUN  chown -R nobody:nogroup ${CYBER_DOJO_HOME}
USER nobody

# - - - - - - - - - - - - - - - - -
# git commit sha image is built from
# - - - - - - - - - - - - - - - - -

ARG SHA
RUN echo ${SHA} > ${CYBER_DOJO_HOME}/sha.txt

# - - - - - - - - - - - - - - - - - -
# bring it up
# - - - - - - - - - - - - - - - - - -

CMD [ "./up.sh" ]

