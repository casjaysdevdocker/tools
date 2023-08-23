mkdir -p "/etc/phppgadmin" "${WWW_ROOT_DIR}"
git clone -q --depth 1 "https://github.com/phppgadmin/phppgadmin" "${WWW_ROOT_DIR}"
cp -Rf "/usr/local/share/template-files/config/phppgadmin/config.php" "/etc/phppgadmin/config.php"
ln -sf "/etc/phppgadmin/config.php" "${WWW_ROOT_DIR}}/conf/config.inc.php"
