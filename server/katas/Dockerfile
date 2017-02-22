FROM alpine:3.4
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN adduser -D -H -u 19661 cyber-dojo

ARG CYBER_DOJO_ZIPPER_KATA_ROOT
USER root
RUN  mkdir -p ${CYBER_DOJO_ZIPPER_KATA_ROOT}
RUN  chown -R cyber-dojo ${CYBER_DOJO_ZIPPER_KATA_ROOT}
VOLUME [ "${CYBER_DOJO_ZIPPER_KATA_ROOT}" ]
