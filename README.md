# [Odoo](https://www.odoo.com "Odoo Website") Database Backup Script

## odoo-db-backup
Collection of Odoo Database Backup Options.

## Odoo Backup Bash Script
This database backup script is useful when database backup require on the same server without filestore. This is OS based backup script so it works on base level to make sure backup runs as expected without fail.

### Manage Historical Database Backups
- One Daily Backup for Latest 1 Week (Total 7 backup)
- One Weekly Backup for Latest 5 Weeks (Total 5 backup)
- One Monthly Backup
- One Yearly Backup

### Setup
Hook it in /etc/crontab for autoback on specified interval. Make sure file has enough executable permissions. Also take care of by which user it will run and that OS user have permissions for backup.

#### File: /etc/crontab
> m h dom mon dow user	command

```<minute> <hour>   * * *   <user-used-to-run-script>    sh /path/to/this/script/odoo-db-backup.sh "<psql-database-name>" >> /path/to/backups/backup-log-file.log```

#### Example: Daily 1:15 O'clock odoo-live psql database backup is run and it will make databases backups without filestore as per procedure defined.
```15 1   * * *   root    sh /odoo/backups/odoo-db-backup.sh "odoo-live" >> /odoo/backups/odoo-db-backup-odoo-live.log```

#### Confirm/change following parameters inside the script.
- DIR="/odoo/backups/$DBNAME"
