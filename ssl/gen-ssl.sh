#!/bin/bash

openssl req -new -x509 -days 365 -nodes -newkey rsa:2048 -keyout priv.key -out cert.crt -subj "/C=TH/ST=Bangkok/L=Dusit/O=EAI/OU=IT/CN=mail.mail123.in.th"
