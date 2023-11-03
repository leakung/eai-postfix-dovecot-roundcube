Demo for thai EAI mail server
- postfix
- dovecot
- roundcube
- mariadb


Fix bug when sending an email and recipient's email address contains a trailing dot (#7899)

.replace(/[^a-z]$/gi,"") replace with .replace(/[^ก-๛a-z]$/gi,"") 
