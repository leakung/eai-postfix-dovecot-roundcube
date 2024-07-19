#!/bin/bash

cat <<EOF >> data/www/config/config.inc.php

    \$config['imap_conn_options'] = [
        'ssl'         => [
            'verify_peer'  => false,
            'verify_peer_name'  => false,
            'allow_self_signed' => true,
        ],
        'tls'         => [
            'verify_peer'  => false,
            'verify_peer_name'  => false,
            'allow_self_signed' => true,
        ],
    ];

    \$config['smtp_conn_options'] = [
        'ssl'         => [
            'verify_peer'  => false,
            'verify_peer_name'  => false,
            'allow_self_signed' => true,
        ],
        'tls'         => [
            'verify_peer'  => false,
            'verify_peer_name'  => false,
            'allow_self_signed' => true,
        ],
    ];
EOF

# fix roundcube for support EAI
# roundcube 1.6.7

sed -i 's/\.replace(\/\[\^a\-z\]$\/gi\,\"\")/.replace(\/[^ก-๛a-z]$\/gi,"")/g' data/www/skins/elastic/ui.min.js

sed -i 's/idn_to_ascii/idn_to_utf8/g' data/www/program/include/rcmail_sendmail.php
sed -i 's/check_email($item)/check_email(rcube_utils::idn_to_ascii($item))/g' data/www/program/include/rcmail_sendmail.php

sed -i 's/idn_to_ascii/idn_to_utf8/g' data/www/program/actions/settings/identity_save.php
sed -i 's/check_email($email)/check_email(rcube_utils::idn_to_ascii($email))/g' data/www/program/actions/settings/identity_save.php