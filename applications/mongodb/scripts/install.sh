mkdir -p "/etc/mongodb"
sh -c "$(curl -q -LSsf "https://rpm.nodesource.com/setup_${NODE_VERSION}.x")" &&
  curl -q -LSsf "https://dl.yarnpkg.com/rpm/yarn.repo" -o /etc/yum.repos.d/yarn.repo &&
  rpm --import "https://dl.yarnpkg.com/rpm/pubkey.gpg" &&
  yum install -yy nodejs yarn &&
  bash /tmp/setup_mongodb.sh
cp -Rf "/tmp/mongo-express" "/usr/local/share/template-files/config"
cp -Rf "/usr/local/share/template-files/config/mongodb/." "/etc/mongodb/"
ln -sf "/etc/mongodb/mongod.conf" "/etc/mongod.conf"
