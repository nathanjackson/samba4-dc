FROM alpine:3.5
MAINTAINER Nathan Jackson <nate.ds.jackson@gmail.com>
RUN apk add -U samba-dc
ADD docker-entrypoint.sh /
EXPOSE 1024 3268 3269 389 135 139 464 53 88 636 445
ENTRYPOINT [ "/docker-entrypoint.sh" ]
