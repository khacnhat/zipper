FROM cyberdojo/sinatra
MAINTAINER Jon Jagger <jon@jaggersoft.com>

RUN adduser -D -H zipper

COPY . /app

ARG PORT
EXPOSE ${PORT}

ENV PORT=${PORT}
CMD [ "./up.sh" ]
