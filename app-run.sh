#!/bin/bash

# create DB data
echo ">> Create DB data"
/bin/bash /opt/init-db.sh

# postconf
echo ">> Running postconf"
postconf -e "myhostname=$HOSTNAME"
postconf -e "mydomain=$DOMAINNAME"
postconf -e "virtual_alias_domains=$DOMAIN_EAI"
postconf -e "smtpd_tls_cert_file=/etc/ssl/cert.crt"
postconf -e "smtpd_tls_key_file=/etc/ssl/priv.key"
postconf -e "myorigin=\$mydomain"
postconf -e "inet_interfaces=all"
postconf -e "inet_protocols=ipv4"
postconf -e "mydestination=mail.\$mydomain"
postconf -e "mynetworks=127.0.0.0/8"
postconf -e "smtpd_sasl_auth_enable=yes"
postconf -e "smtpd_sasl_type=dovecot"
postconf -e "smtpd_sasl_path=private/auth"
postconf -e "smtpd_sasl_authenticated_header=yes"
postconf -e "broken_sasl_auth_clients=yes"
postconf -e "smtpd_use_tls=yes"
postconf -e "smtpd_recipient_restrictions=permit_mynetworks, permit_sasl_authenticated, reject_unauth_destination"
postconf -e "smtpd_tls_auth_only=yes"
postconf -e "smtpd_tls_loglevel=1"
postconf -e "virtual_mailbox_base=/home/vmail"
postconf -e "virtual_mailbox_maps=mysql:/etc/postfix/mysql/mysql-virtual_mailboxes.cf"
postconf -e "virtual_mailbox_domains=mysql:/etc/postfix/mysql/mysql-virtual_domains.cf"
postconf -e "virtual_alias_maps=mysql:/etc/postfix/mysql/mysql-virtual_forwardings.cf, mysql:/etc/postfix/mysql/mysql-virtual_email2email.cf"
postconf -e "virtual_uid_maps=static:5000"
postconf -e "virtual_gid_maps=static:5000"
postconf -e "virtual_transport=dovecot"
postconf -e "proxy_read_maps=\$local_recipient_maps \$mydestination \$virtual_alias_maps \$virtual_alias_domains \$virtual_mailbox_maps \$virtual_mailbox_domains \$relay_recipient_maps \$relay_domains \$canonical_maps \$sender_canonical_maps \$recipient_canonical_maps \$relocated_maps \$transport_maps \$mynetworks"
postconf -e "smtputf8_enable=yes"
postconf -e "maillog_file=/var/log/mail.log"
postconf -e "dovecot_destination_recipient_limit = 1"

postconf -M smtps/inet="smtps inet n - - - - smtpd" && \
postconf -P "smtps/inet/syslog_name=postfix/smtps" && \
postconf -P "smtps/inet/smtpd_tls_wrappermode=yes" && \
postconf -P "smtps/inet/smtpd_sasl_auth_enable=yes" && \
postconf -P "smtps/inet/smtpd_client_restrictions=permit_sasl_authenticated,reject" && \
postconf -P "smtps/inet/smtpd_relay_restrictions=permit_sasl_authenticated,reject" && \
postconf -P "smtps/inet/milter_macro_daemon_name=ORIGINATING" && \
postconf -M dovecot/unix="dovecot   unix  -       n       n       -       -       pipe flags=DRhu user=vmail:vmail argv=/usr/lib/dovecot/deliver -f \${sender} -d \${recipient}"

postconf -M submission/inet="submission inet n - - - - smtpd" && \
postconf -P "submission/inet/smtpd_sasl_auth_enable=yes" && \
postconf -P "submission/inet/smtpd_tls_security_level=encrypt" && \
postconf -P "submission/inet/smtpd_tls_auth_only=yes"

# chown /home/vmail
echo ">> Chown /home/vmail"
chown vmail: /home/vmail

# starting services
echo ">> starting the services"
service dovecot start
service postfix start

# print logs
echo ">> printing the logs"
tail -F /var/log/mail.log

