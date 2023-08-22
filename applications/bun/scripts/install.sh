curl -q -fsSL "https://bun.sh/install" | bash &&
  ln -sf /usr/local/share/bun/bin/bun /usr/local/bin &&
  mkdir -p "${DEFAULT_DATA_DIR}/htdocs/www" &&
  git clone "https://github.com/casjay-templates/bunjs" "${DEFAULT_DATA_DIR}/htdocs/www/" &&
  rm -Rf ${DEFAULT_DATA_DIR}/htdocs/www/.git &&
  cd "${DEFAULT_DATA_DIR}/htdocs/www" &&
  /usr/local/bin/bun install
