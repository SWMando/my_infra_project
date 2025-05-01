# Backup SLA

## Coverage

We back up services that satisfy at least one of these criteria:
 - are primary source of truth for particular data
 - contain customer and/or client data
 - are not feasible (or very costly) to restore by other means

Services that are backed up:
 - MySQL
 - InfluxDB

## Schedule

MySQL backups are created every night at 00:30 UTC time; it takes up to 10 minute to create and store the backup.

InfluxDB backups are created every night at 00:30 UTC time; it takes up to 10 minute to create and store the backup.

All backups are started automatically by `cron` service.

Backup RPO (recovery point objective) is:
 - 24 hours + 10 minute for backup to be finished for MySQL
 - 24 hours + 10 minute for backup to be finished for InfluxDB

## Storage

MySQL and InfluxDB backups are uploaded to the backup server.

Ansible Repo is mirrored to the internal Git server.

Backup data from both servers will be synchronized to encrypted AWS S3 bucket in future (work in progress).


## Retention

MySQL and InfluxDB backups are stored for 30 days; 30 versions (recovery points) are available to restore.

Git backups are stored 6 month; 2 versions per hours * 24 hours * 6 months = 8640 versions (recovery points) are available to restore.

## Usability checks

MySQL backups are verified every week on Saturday by automated test.

InfluxDB backups are verified every week on Saturday by automated test.


## Restore process

Service is recovered from the backup in case of an incident, and when service cannot be restored in any other way.

RTO (recovery time objective) is:
 - 1 hour for MySQL
 - 1 hour for InfluxDB
 - 1 hour for Git repo

Detailed backup restore procedure is documented in the [backup_restore.md](./backup_restore.md).
