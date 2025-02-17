#!/usr/bin/env bash
##
# This section should match your Makefile
##
PY=$(pwd)/bin/python
PELICAN=$(pwd)/bin/pelican
PELICANOPTS=

BASEDIR=$(pwd)
INPUTDIR=$BASEDIR/content
OUTPUTDIR=$BASEDIR/output
CONFFILE=$BASEDIR/pelicanconf.py

###
# Don't change stuff below here unless you are sure
###

SRV_PID=$BASEDIR/srv.pid
PELICAN_PID=$BASEDIR/pelican.pid

function usage(){
  echo "usage: $0 (stop) (start) (restart) [port]"
  echo "This starts pelican in debug and reload mode and then launches"
  echo "A pelican.server to help site development. It doesn't read"
  echo "your pelican options so you edit any paths in your Makefile"
  echo "you will need to edit it as well"
  exit 3
}

function alive() {
  kill -0 $1 >/dev/null 2>&1
}

function shut_down(){
  PID=$(cat $SRV_PID)
  if [[ $? -eq 0 ]]; then
    if alive $PID; then
      echo "Killing pelican.server"
      kill -9 $PID
    else
      echo "Stale PID, deleting"
    fi
    rm $SRV_PID
  else
    echo "pelican.server PIDFile not found"
  fi

  PID=$(cat $PELICAN_PID)
  if [[ $? -eq 0 ]]; then
    if alive $PID; then
      echo "Killing Pelican"
      kill -9 $PID
    else
      echo "Stale PID, deleting"
    fi
    rm $PELICAN_PID
  else
    echo "Pelican PIDFile not found"
  fi
}

function start_up(){
  mkdir -p log
  rm log/*
  local srv_stdout="${PWD}/log/server_stdout.log"; echo -n "" > $srv_stdout
  local srv_stderr="${PWD}/log/server_stderr.log"; echo -n "" > $srv_stderr
  local pelican_stdout="${PWD}/log/pelican_stdout.log"; echo -n "" > $pelican_stdout
  local pelican_stderr="${PWD}/log/pelican_stderr.log"; echo -n "" > $pelican_stderr

  local port=$1
  echo "Starting up Pelican and pelican.server"
  shift
  $PELICAN --debug --autoreload -r $INPUTDIR -o $OUTPUTDIR -s $CONFFILE $PELICANOPTS 1>> $pelican_stdout 2>> $pelican_stderr &
  pelican_pid=$!
  echo $pelican_pid > $PELICAN_PID
  cd $OUTPUTDIR
  $PY -m pelican.server $port 1>> $srv_stderr 2>> $srv_stdout &
  srv_pid=$!
  echo $srv_pid > $SRV_PID
  cd $BASEDIR
  sleep 1
  if ! alive $pelican_pid ; then
    echo "Pelican didn't start. Is the pelican package installed?"
    return 1
  elif ! alive $srv_pid ; then
    echo "pelican.server didn't start. Is there something else which uses port 8000?"
    return 1
  fi
  echo 'Pelican and pelican.server processes now running in background.'
}

###
#  MAIN
###
[[ ($# -eq 0) || ($# -gt 2) ]] && usage
port=''
[[ $# -eq 2 ]] && port=$2

if [[ $1 == "stop" ]]; then
  shut_down
  echo "Log files are available for inspection in ./log folder"
elif [[ $1 == "restart" ]]; then
  shut_down
  start_up $port
elif [[ $1 == "start" ]]; then
  if ! start_up $port; then
    shut_down
  fi
else
  usage
fi
