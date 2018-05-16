FROM debian:jessie-slim

COPY baseWeb.sh /baseWeb.sh

CMD ["/baseWeb.sh"]

ENV project-name project

EXPOSE 22,80,3306
CMD ["/usr/sbin/sshd", "-D"]
