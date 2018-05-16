FROM debian:jessie-slim

COPY baseWeb.sh /baseWeb.sh

ENTRYPOINT ["baseWeb.sh"]

ENV project-name project

EXPOSE 22/tcp
EXPOSE 80/tcp
EXPOSE 3306/tcp
