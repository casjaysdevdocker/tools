EXEC_CMD_BIN="jekyll"                                             # command to execute
EXEC_CMD_ARGS="serve --force_polling -H 0.0.0.0 -P $SERVICE_PORT" # command arguments

[ -f "$WORK_DIR/.nojekyll" ] && HAS_HTML="true"
[ -f "$WORK_DIR/Gemfile" ] && HAS_GEMFILE="true"
[ -f "$WORK_DIR/_config.yml" ] && HAS_JEKYLL="true"

[ -f "$WORK_DIR/.env" ] && . "$WORK_DIR/.env"
if [ -z "$HAS_HTML" ] && [ -z "$HAS_GEMFILE" ] && [ -z "$HAS_JEKYLL" ]; then
  echo "NOTE: I don't see a .nojekyll, Gemfile, or a _config.yml so I don't think there's a jekyll site here"
  echo "Either you didn't mount a volume, or you mounted it incorrectly."
  echo "Be sure you're in your jekyll site root and use something like this to launch"
  echo ""
  echo "docker run --name jekyll --rm -p 15999:$SERVICE_PORT -v \$PWD:/app casjaysdevdocker/jekyll"
  exit 1
else
  mkdir -p "$WORK_DIR" && cd "$WORK_DIR" || exit 1
  if [ ! -f "$workdir/.nojekyll" ]; then
    bundle install --retry 5 --jobs 20
  fi
fi
