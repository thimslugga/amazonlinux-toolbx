#!/bin/bash

MAIL_FROM_USER=root
if [ -f /etc/systemd-email.conf ]; then
    source /etc/systemd-email.conf
fi

STATUS=$(systemctl is-failed "$2")

/usr/sbin/sendmail -t <<ERRMAIL
To: $MAIL_TO
From: $1 <$MAIL_FROM_USER@$MAIL_FROM_DOMAIN>
Subject: ${STATUS^^}: $2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8

$(systemctl status --full --lines 200 "$2")
ERRMAIL
