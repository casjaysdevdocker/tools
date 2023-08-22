SERVICE_USER="mysql"                                         # execute command as another user
EXEC_CMD_BIN="mysqld"                                        # command to execute
EXEC_CMD_ARGS="--user=$SERVICE_USER --datadir=$DATABASE_DIR" # command arguments

if [ ! -d "$DATABASE_DIR/mysql" ] || [ ! -f "$DATABASE_DIR/ibdata1" ]; then
  mkdir -p "$DATABASE_DIR" && chown -Rf $user:$user "$DATABASE_DIR"
  mysql_install_db --datadir=$DATABASE_DIR --user=$user 2>/dev/null
fi

(
  if [ -f "$CONF_DIR/mysql/init.sh" ]; then
    bash -c "$CONF_DIR/mysql/init.sh"
  fi
  if [ -n "$DATABASE_CREATE" ]; then
    mysql -v -u $runas <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS $DATABASE_CREATE;
MYSQL_SCRIPT
  fi
  if [ "$user_name" != "root" ] && [ -n "$user_name" ]; then
    mysql -v -u $runas <<MYSQL_SCRIPT
CREATE USER IF NOT EXISTS '$user_name'@'%' IDENTIFIED BY '$user_pass';
MYSQL_SCRIPT
  fi
  if [ "$user_name" != "root" ] && [ -n "$DATABASE_CREATE" ]; then
    mysql -v -u $runas <<MYSQL_SCRIPT
GRANT ALL PRIVILEGES ON $DATABASE_CREATE.* TO '$user_name'@'%';
MYSQL_SCRIPT
  elif [ "$user_name" = "root" ] && [ -n "$DATABASE_CREATE" ]; then
    mysql -v -u $runas <<MYSQL_SCRIPT
GRANT ALL PRIVILEGES ON $DATABASE_CREATE.* TO 'root'@'localhost';
MYSQL_SCRIPT
  fi
  mysql -v -u $runas <<MYSQL_SCRIPT
ALTER USER 'root'@'localhost' IDENTIFIED BY '$root_user_pass';
FLUSH PRIVILEGES;
MYSQL_SCRIPT
) 2>/dev/stderr >/dev/null
