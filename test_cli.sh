#!/usr/bin/env bash
# Copyright (c) 2011 Concurrent, Inc.

#######################

if [ -z "$MT_PATH" ]
then
  if [ -h $0 ]
  then
    cd `dirname $0`
    MT_PATH=`basename $0`

    while [ -h "$MT_PATH" ]
    do
      MT_PATH=`readlink $MT_PATH`
      cd `dirname $MT_PATH`
      MT_PATH=`basename $MT_PATH`
    done
    
    MT_PATH=`cd .. && pwd -P`
  else
    MT_PATH=`dirname $0`/..
    MT_PATH=`cd $MT_PATH && pwd -P`
  fi
fi

mt_log_use_color=true
mt_log_verbose=true
mt_log_stack_depth=0

if  [ "$color" = "always" ] || (test -t 1); then
  mt_log_red=$(printf "\033[31m")
  mt_log_green=$(printf "\033[32m")
  mt_log_yellow=$(printf "\033[33m")
  mt_log_blue=$(printf "\033[34m")
  mt_log_clear=$(printf "\033[m")
fi

mt_log_hilite_pattern="s/INFO/${mt_log_green}INFO${mt_log_blue}/"
mt_log_info_pattern="s/INFO/${mt_log_green}INFO${mt_log_clear}/"
mt_log_warn_pattern="s/WARN/${mt_log_yellow}WARN${mt_log_clear}/"
mt_log_error_pattern="s/ERROR/${mt_log_red}ERROR${mt_log_clear}/"
mt_log_info_highlight_strings="cascade flow multitool"

log ()
{
  [ "$mt_log_stack_depth" -gt 0 ] && printf '\t%.0s' {1..$mt_log_stack_depth}
  echo "$@"
}

info ()
{
  mt_log_stack_depth=0
  if [ -n "$mt_log_verbose" ]
  then
    if [ -n "$mt_log_use_color" ]
    then
      for hilite in $mt_log_info_highlight_strings
      do
        if echo "$@" | grep "INFO $hilite" > /dev/null
        then
          echo `echo "$@" | sed $mt_log_hilite_pattern`$mt_log_clear
          return
        fi
      done

      echo `echo "$@" | sed $mt_log_info_pattern`$mt_log_clear
    else
      echo "$@"
    fi
  fi
}

warn ()
{
  mt_log_stack_depth=0
  if [ -n "$mt_log_use_color" ]
  then
    echo `echo "$@" | sed $mt_log_warn_pattern`$mt_log_clear
  else
    echo "$@"
  fi
}

error ()
{
  mt_log_stack_depth=0
  if [ -n "$mt_log_use_color" ]
  then
    echo `echo "$@" | sed $mt_log_error_pattern`$mt_log_clear
  else
    echo "$@"
  fi
}

stacktrace ()
{
  log $@
  mt_log_stack_depth=$(($mt_log_stack_depth + 1))
}

# Override module#exit
module_exit ()
{
  code=1

  if [ $# -gt 0 ]
  then
    echo "ERROR $@"
  fi

  exit $code
}

mt_run ()
{
  if [ $# -eq 0 ]
  then
    echo "No arguments specified"
    exit 1
  else
    $HADOOP_BIN jar $mt_jar_path $@ 2>&1 | while read line; do
      if echo $line | grep INFO > /dev/null; then
        info $line
      elif echo $line | grep WARN > /dev/null; then
        warn $line
      elif echo $line | grep ERROR > /dev/null; then
        error $line
      elif echo $line | grep Exception > /dev/null; then
        stacktrace $line
      elif echo $line | grep "^error: " > /dev/null; then
        echo $line
        exit 1
      elif [ -n "$mt_log_verbose" ]; then
        log $line
      fi
    done
  fi
}

#######################

/bin/date -u

HADOOP_BIN=/Users/paco/src/hadoop-0.20.205.0/bin/hadoop
mt_jar_path=./build/multitool.jar

mt_run $@
