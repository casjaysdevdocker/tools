mkdir -p /var/lib/docker/storage/zabbix/{mysql,config,postfix} && chmod -Rf 777 /var/lib/docker/storage/zabbix

docker run -d \
--name zabbix \
--hostname zabbix \
--restart always \
--privileged \
-p 40080:80 \
-p 40081:443
-p 10051:10051 \
--volume /var/lib/docker/storage/zabbix/mysql:/var/lib/mysql \
--volume /var/lib/docker/storage/zabbix/config:/etc/zabbix \
--volume /var/lib/docker/storage/zabbix/postfix:/etc/postfix \
registry.casjay.in/latest/zabbix:4


docker exec -it -u root zabbix /bin/bash
edit /etc/postfix/main.cf
as it just relays mail through your main server

sql root user has no password
sql username is zabbix
sql database password is password
zabbix web default user name is Admin, password zabbix

https://www.zabbix.com/download?zabbix=4.0&os_distribution=raspbian&os_version=stretch&db=MySQL
