FROM ubuntu:22.04

ARG MARIADB_PASSWORD

ARG HOSTNAME
ARG DOMAINNAME
ARG DOMAIN_EAI
ARG DOMAIN_PUNNY

ARG EAI_DB
ARG EAI_USER_DB
ARG EAI_PASSWORD_DB

ARG EMAIL_USER
ARG EMAIL_EAI_USER
ARG EMAIL_PASSWORD

ARG RC_DB
ARG RC_USER
ARG RC_PASSWORD

ENV MARIADB_PASSWORD $MARIADB_PASSWORD

ENV HOSTNAME $HOSTNAME
ENV DOMAINNAME $DOMAINNAME
ENV DOMAIN_EAI $DOMAIN_EAI
ENV DOMAIN_PUNNY $DOMAIN_PUNNY

ENV EAI_DB $EAI_DB
ENV EAI_USER_DB $EAI_USER_DB
ENV EAI_PASSWORD_DB $EAI_PASSWORD_DB

ENV EMAIL_USER $EMAIL_USER
ENV EMAIL_EAI_USER $EMAIL_EAI_USER
ENV EMAIL_PASSWORD $EMAIL_PASSWORD

ENV RC_DB $RC_DB
ENV RC_USER $RC_USER
ENV RC_PASSWORD $RC_PASSWORD

ENV TZ=Asia/Bangkok
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt -y install postfix postfix-mysql
RUN apt -y install dovecot-core dovecot-mysql dovecot-imapd dovecot-pop3d dovecot-lmtpd
RUN apt -y install mariadb-client tzdata rsyslog

RUN groupadd -g 5000 vmail
RUN useradd -g vmail -u 5000 vmail -d /home/vmail -m

COPY ssl/ /etc/ssl/

COPY postfix-mysql /etc/postfix/mysql
RUN chmod -R 640 /etc/postfix/mysql/
RUN chown -R root:root /etc/postfix/mysql/
RUN sed -i -e 's/EAI_DB/'$EAI_DB'/g' \
	-e 's/EAI_USER_DB/'$EAI_USER_DB'/g' \
	-e 's/EAI_PASSWORD_DB/'$EAI_PASSWORD_DB'/g' \
	/etc/postfix/mysql/*.cf

COPY dovecot/ /etc/dovecot/
RUN sed -i -e 's/EAI_DB/'$EAI_DB'/g' \
        -e 's/EAI_USER_DB/'$EAI_USER_DB'/g' \
        -e 's/EAI_PASSWORD_DB/'$EAI_PASSWORD_DB'/g' \
        /etc/dovecot/dovecot-sql.conf.ext

RUN touch /var/log/dovecot.log

COPY init-db.sh /opt/init-db.sh

COPY app-run.sh /opt/run.sh
ENTRYPOINT ["/bin/bash", "/opt/run.sh"]
