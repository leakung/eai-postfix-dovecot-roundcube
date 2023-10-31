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

sed -i 's/\.replace(\/\[\^a\-z\]$\/gi\,\"\")//g' data/www/skins/elastic/ui.min.js
