#### Install and configure infrastructure with Ansible:
```bash
ansible-playbook infra.yaml
```
Just in case to notice differences after you restore from backup try to
add one or two unique entries so you know that there were changes

#### Restore MySQL data from the backup:
```bash
sudo -u backup duplicity --no-encryption restore rsync://swmando@backup.itqurd.az/mysql /home/backup/restore/mysql
sudo mysql agama < /home/backup/restore/mysql/agama.sql
```
To verify please run:
```bash
sudo mysql -u root -p -e "SELECT * FROM agama.item;"
```
When you are asked to enter password just press ENTER.
View the output to check if the data has been restored to desired state.

#### Restore InfluxDB data from the backup:
```bash
sudo -u backup duplicity --no-encryption restore rsync://swmando@backup.itqurd.az/influxdb /home/backup/restore/influxdb
sudo systemctl stop telegraf
influx -execute 'DROP DATABASE telegraf'
influxd restore -portable -db telegraf /home/backup/restore/influxdb
```
Start telegraf back again.
As a result you should have the backed up database uploaded to the telegraf. Service should be active and green :)
```bash
sudo systemctl start telegraf
```
To verify please run:
```bash
sudo influx -database 'telegraf' -execute 'SELECT COUNT(*) FROM syslog'
```
