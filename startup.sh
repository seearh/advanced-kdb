#! /usr/bin/env bash

# Usage: bash startup.sh [-m MODE] [-d DBDIR] [-t TICKERPORT] [-r RDBPORT1,RDBPORT2] [COMPONENT...]
# positional arguments:
#   COMPONENT   cpnt   Component to start, 1 (tickerplant), 2 (RDBs), 3 (feedhandler), 4 (CEP)
# option arguments:
#   MODE         mode   START/STOP/TEST components
#   TICKERPORT   port   Port to start tickerplant
#   DBDIR        dir    Relative directory to HDB
#   RDBPORT      port   Comma-separated ports to start 2 RDBs

declare -A component_names
component_names[1]=Tickerplant
component_names[2]=RDBs
component_names[3]=Feedhandler
component_names[4]=CEP

testMode() {
  echo "Checking for running tick processes..."
  pgrep -a -f 'q tick' | grep -v rlwrap
}

startComp() {
  local component=$1
  case $component in
    1)nohup $QHOME/l64/q tick.q $logDir sym -p $tport >/dev/null 2>&1 &;;
    2)
      nohup $QHOME/l64/q tick/r.q :$tport -p ${rport[0]} -tabs trades,quotes $([[ -v dbDir ]] && echo "-db $dbDir") >/dev/null 2>&1 &
      nohup $QHOME/l64/q tick/r.q :$tport -p ${rport[1]} -tabs agg $([[ -v dbDir ]] && echo "-db $dbDir") >/dev/null 2>&1 &
      ;;
    3)nohup $QHOME/l64/q tick/ssl.q sym :$tport >/dev/null 2>&1 &;;
    4)nohup $QHOME/l64/q tick/cep.q :$tport >/dev/null 2>&1 &;;
    *)echo "Unknown component provided: $component"
  esac
}

killComp() {
  local -a proc_cmd
  proc_cmd[1]="q tick.q"
  proc_cmd[2]="q tick/r.q"
  proc_cmd[3]="q tick/ssl.q"
  proc_cmd[4]="q tick/cep.q"
  pkill --signal SIGKILL -f "${proc_cmd[$1]}"
  return $?
}

# Options
while getopts d:m:p:r:t: opt
do
  case $opt in
    d)dbDir=$OPTARG;;
    m)declare -u mode=$(echo $OPTARG | sed 's/ //g');;
    r)declare -a rport=($(echo $OPTARG | tr "," " "));;
    t)declare -i tport=$OPTARG;;
  esac
done

# Arguments
declare -a components; components+=(${@:$OPTIND})

# Defaults
[[ ${components[@]} = "" ]] && components=({1..4})
[[ ! -v tport ]] && tport=5010
[[ ! -v rport ]] && rport=(5011 5012)
[[ ! -v mode ]] && mode=TEST

case $mode in
  START)
    for component in ${components[@]}; do
      startComp $component && echo "${component_names[$component]} started"
    done
    exit 0
  ;;
  STOP)
    testMode
    for component in ${components[@]}; do
      killComp $component && echo "${component_names[$component]} killed"
    done
    exit 0
    ;;
  TEST)echo "Running in TEST mode"; testMode; exit 0;;
  *)
    echo "Valid -m options: TEST / START / STOP"; exit 1
    ;;
esac
