FROM debian:jessie-slim

COPY baseWeb.sh /usr/local/bin

ENV DB_ROOT_PASS tempPass
ENV DB_USER myuser
ENV DB_USER_PASS tempPass
ENV NOTVISIBLE "in users profile"
ENV PROJECT_NAME project

RUN chmod +x /usr/local/bin/baseWeb.sh
RUN ./usr/local/bin/baseWeb.sh

EXPOSE 22/tcp
EXPOSE 80/tcp
EXPOSE 443/tcp
