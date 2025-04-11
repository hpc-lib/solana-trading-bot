#!/bin/bash

# 定义日志文件路径
LOG_FILE="./start.log"
PID_FILE="./process.pid"

# 启动项目
start() {
  if [ -f "$PID_FILE" ]; then
    echo "Server is already running. PID: $(cat $PID_FILE)"
    exit 1
  fi

  echo "Starting server..."
  nohup npm run start > "$LOG_FILE" 2>&1 &
  echo $! > "$PID_FILE"
  echo "Server started. PID: $(cat $PID_FILE)"
}

# 停止项目
stop() {
  if [ ! -f "$PID_FILE" ]; then
    echo "Server is not running."
    exit 1
  fi

  echo "Stopping server..."
  kill $(cat "$PID_FILE")
  rm -f "$PID_FILE"
  echo "Server stopped."
}

# 重启项目
restart() {
  stop
  start
}

# 查看帮助
help() {
  echo "Usage: ./manage.sh [start|stop|restart]"
  echo "  start   - Start the server"
  echo "  stop    - Stop the server"
  echo "  restart - Restart the server"
}

# 根据传入的参数执行对应操作
case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  *)
    help
    ;;
esac