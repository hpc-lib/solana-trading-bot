#!/bin/bash

# 定义日志文件路径
LOG_FILE="./start.log"
PID_FILE="./process.pid"

# 获取实际运行的子进程 PID
get_actual_pid() {
  local parent_pid=$1
  ps -o pid --no-headers --ppid "$parent_pid" | head -n 1
}

# 启动项目
start() {
  if [ -f "$PID_FILE" ]; then
    echo "Server is already running. PID: $(cat $PID_FILE)"
    exit 1
  fi

  echo "Starting server..."
  nohup npm run start > "$LOG_FILE" 2>&1 &
  parent_pid=$!

  # 等待 1 秒，确保子进程启动完成
  sleep 1

  actual_pid=$(get_actual_pid "$parent_pid")
  if [ -z "$actual_pid" ]; then
    echo "Failed to get the actual PID of the running process."
    exit 1
  fi

  echo "$actual_pid" > "$PID_FILE"
  echo "Server started. PID: $actual_pid"
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