FROM  cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

# - - - - - - - - - - - - - - - - - -
# copy source & set ownership
# - - - - - - - - - - - - - - - - - -

ARG                            ZIPPER_HOME=/app
COPY .                       ${ZIPPER_HOME}
RUN  chown -R nobody:nogroup ${ZIPPER_HOME}
USER nobody

# - - - - - - - - - - - - - - - - -
# git commit sha image is built from
# - - - - - - - - - - - - - - - - -

ARG SHA
RUN echo ${SHA} > ${ZIPPER_HOME}/sha.txt

# - - - - - - - - - - - - - - - - - -
# bring it up
# - - - - - - - - - - - - - - - - - -

EXPOSE 4587
CMD [ "./up.sh" ]

