ARG PHPMYADMIN_VERSION="5.2.1"

PHPMYADMIN_VERSION="${PHPMYADMIN_VERSION:-$(curl -q -LSsf https://api.github.com/repos/phpmyadmin/phpmyadmin/releases | grep '"name"' | sed 's|.*: ||g;s|"||g;s|,||g' | sort -Vr | head -n1 | grep '^' || echo "5.2.1")}"
mkdir -p "/var/www" "/etc/phpmyadmin"
[ -e "/etc/php" ] && rm -Rf "/etc/php"
[ -e "/etc/my.cnf" ] && rm -Rf "/etc/my.cnf"
[ -d "/etc/apache2/conf.d" ] && rm -Rf "/etc/apache2/conf.d"
[ -d "/var/www/phpmyadmin" ] && rm -Rf "/var/www/phpmyadmin"
[ -d "/tmp/etc/php" ] && mv -f "/tmp/etc/php" "/tmp/etc/${PHP_VERSION}"
[ -d "/etc/${PHP_VERSION}" ] && ln -sf "/etc/${PHP_VERSION}" "/etc/php"
curl -q -LSsf "https://files.phpmyadmin.net/phpMyAdmin/${PHPMYADMIN_VERSION}/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages.zip" -o "/tmp/phpmyadmin.zip" &&
  unzip -q "/tmp/phpmyadmin.zip" -d "/tmp" && rm -Rf "/tmp/phpmyadmin.zip"
mv -f "/tmp/phpMyAdmin-${PHPMYADMIN_VERSION}-all-languages" "/var/www/phpmyadmin"
git clone --depth 1 "https://github.com/phpmyadmin/themes" "/tmp/themes"
for d in blueberry boodark bootstrap dark-orange darkmod-neo darkwolf eyed fallen fistu metro mhn; do
  mkdir -p "/var/www/phpmyadmin/themes/$d" &&
    [ -d "/tmp/themes/$d" ] && cp -Rf "/tmp/themes/$d/." "/var/www/phpmyadmin/themes/$d/"
done
cp -Rf "/tmp/etc/." "/etc/"
cp -Rf "/etc/mysql" "/usr/local/share/template-files/config/mysql"
ln -sf "/etc/phpmyadmin/config.php" "/var/www/phpmyadmin/config.inc.php"
chmod -f 777 "/var/www/phpmyadmin"
chown -Rf apache:apache "/var/www"
