FROM  cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

# - - - - - - - - - - - - - - - - - -
# copy source & set ownership
# - - - - - - - - - - - - - - - - - -

ARG                            ZIPPER_HOME=/app
COPY .                       ${ZIPPER_HOME}
RUN  chown -R nobody:nogroup ${ZIPPER_HOME}
USER nobody

# - - - - - - - - - - - - - - - - - -
# bring it up
# - - - - - - - - - - - - - - - - - -

EXPOSE 4588
CMD [ "./up.sh" ]
