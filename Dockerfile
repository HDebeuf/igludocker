FROM debian:jessie-slim

COPY baseWeb.sh /usr/local/bin

ENV DB_ROOT_PASS root
ENV DB_USER user
ENV DB_USER_PASS root

RUN chmod +x /usr/local/bin/baseWeb.sh
RUN ./usr/local/bin/baseWeb.sh


ENV project-name project

EXPOSE 22/tcp
EXPOSE 80/tcp
EXPOSE 3306/tcp
