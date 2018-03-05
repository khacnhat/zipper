FROM  alpine:latest
LABEL maintainer=jon@jaggersoft.com

# - - - - - - - - - - - - - - - - - -
# install ruby+
# tar is needed to tar-pipe test coverage out of tmpfs.
# git is needed for the service
# - - - - - - - - - - - - - - - - - -

RUN apk --update --no-cache add \
    bash \
    ruby-bundler \
    ruby-dev \
    tar

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

# - - - - - - - - - - - - - -
# install non-commons
# - - - - - - - - - - - - - -

RUN apk --update --no-cache add \
    git

# - - - - - - - - - - - - - - - - - -
# copy source & set ownership
# - - - - - - - - - - - - - - - - - -

COPY . ${CYBER_DOJO_HOME}
RUN  chown -R nobody:nogroup ${CYBER_DOJO_HOME}
USER nobody

# - - - - - - - - - - - - - - - - - -
# bring it up
# - - - - - - - - - - - - - - - - - -

ARG PORT
EXPOSE ${PORT}
ENV PORT=${PORT}

CMD [ "./up.sh" ]

