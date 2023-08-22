EXEC_CMD_ARGS="apprise"                                                                                        # command arguments
EXEC_PRE_SCRIPT="gunicorn -c $WORK_DIR/gunicorn.conf.py -b :$SERVICE_PORT --worker-tmp-dir /dev/shm core.wsgi" # execute script before

  __replace "0.0.0.0:8000" "0.0.0.0:$SERVICE_PORT" "$WORK_DIR/gunicorn.conf.py"
