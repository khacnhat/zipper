FROM  cyberdojo/rack-base
LABEL maintainer=jon@jaggersoft.com

ARG                            ZIPPER_HOME=/app
COPY .                       ${ZIPPER_HOME}
RUN  chown -R nobody:nogroup ${ZIPPER_HOME}

ARG SHA
RUN echo ${SHA} > ${ZIPPER_HOME}/sha.txt

EXPOSE 4587
USER nobody
CMD [ "./up.sh" ]
