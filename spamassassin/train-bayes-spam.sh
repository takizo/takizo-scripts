#!/bin/bash

## Submit SPAM email which forwarded to antispam@<domain.com>
## Mailbox running Maildir format
## Server is running Centos 6 with Amavis-new


# Submit email to learn with bayes
/usr/bin/sa-learn --spam --showdots --dbpath /var/spool/amavisd/.spamassassin/ /mail/domain.com/antispam/Maildir/{cur,new} -D


# after submission for learning. Clean old email (yesterday email which already learned)
/bin/find /mail/domain.com/antispam/Maildir/new/ -type f -mtime +1 -exec rm -rf {} \;
