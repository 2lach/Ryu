#!/bin/bash

# Author:  Stefan Lachmann, 2lach on Github
# MIT LiCENSE

# About:
# Ryu
# Because rsync is an awesome tool!
# But sometimes all those rsync commands can be com complex and really hard to remember

# Ryu makes rsync less complex

# check if dependencies are installed
function _exists() {
  if (hash "$@" 2>/dev/null); then
    # echo 'we good!'
    return 0
  else
    # echo 'dependencies missing'
    exit 1
  fi
}

function arg_exists() {
  if [[ -z "$1" ]]; then
    RYU_HELP
  # else
  #   echo "$1"
  fi
}

function RYU_HELP() {
  cat <<EOF

RYU
download:
  ryu download [USER@HOST:PATH/ON/HOST] [DESTINATION]
    - assumes DESTINATION is current path if left empty

upload:
  ryu upload [SRC] [USER@HOST:PATH/ON/HOST]
    - assumes SRC is current path if left empty

 copy
  ryu copy [SRC] [DESTINATION]
  - assumes SRC is current path if left empty

 help
  ryu help 
  - shows this message

SYNOPSIS
Because Rsync is awesome but really a lot of commands to recall, especially if your like me
and sometimes just wanna get shit done without having to remember all the options, but still want them.
That's it!

EOF
  exit 0
}

# verify that needed dependencies exists
_exists rsync

# get ryu command
arg_exists "$1" && RYU_COMMAND="$1"
if [[ -z "$1" ]]; then
  RYU_HELP
fi

# get RYU_SRC
arg_exists "$2"
if [[ $2 == *":"* ]] && [[ -z "$3" ]]; then
  RYU_DESTINATION="$2"
  RYU_SRC="$PWD"
else
  RYU_SRC="$2"
fi

arg_exists "$3" && RYU_DESTINATION="$3"

echo "$RYU_COMMAND" "$RYU_SRC" "$RYU_DESTINATION"

function RYU_UPLOAD() {
  rsync -WavPr --human-readable --info=progress2 "$RYU_SRC" "$RYU_DESTINATION"
}

function RYU_DOWNLOAD() {
  rsync -WavPr --human-readable --info=progress2 "$RYU_DESTINATION" "$RYU_SRC"
}

function RYU_COPY() {
  rsync -WavPr --human-readable --info=progress2 "$RYU_SRC" "$RYU_DESTINATION"
}

function success() {
  _exists afplay && afplay './Hadouken.mp3'
  ! _exists afplay &&
    echo "Ryu was successful"
  echo ""
  echo "
H)    hh              d)                 k)
H)    hh              d)                 k)
H)hhhhhh a)AAAA   d)DDDD  o)OOO  u)   UU k)  KK e)EEEEE n)NNNN
H)    hh  a)AAA  d)   DD o)   OO u)   UU k)KK   e)EEEE  n)   NN
H)    hh a)   A  d)   DD o)   OO u)   UU k) KK  e)      n)   NN
H)    hh  a)AAAA  d)DDDD  o)OOO   u)UUU  k)  KK  e)EEEE n)   NN
"
}
function fail() {
  echo "Ryu failed..."
}

function GET_METHOD() {
  echo "GET_METHOD"
  if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "help" ]]; then
    RYU_HELP

  elif [[ "$1" == "up" ]] || [[ "$1" == "upload" ]] || [[ "$1" == "UPLOAD" ]]; then
    RYU_UPLOAD "$RYU_SRC" "$RYU_DESTINATION"
    if RYU_UPLOAD; then
      success
    else
      fail
    fi

  elif
    [[ "$1" == "down" ]] || [[ "$1" == "download" ]] || [[ "$1" == "DOWNLOAD" ]]
  then
    RYU_DOWNLOAD "$RYU_SRC" "$RYU_DESTINATION"
    if RYU_DOWNLOAD; then
      success
    else
      fail
    fi

  elif
    [[ "$1" == "cp" ]] || [[ "$1" == "copy" ]] || [[ "$1" == "COPY" ]]
  then
    RYU_COPY "$RYU_SRC" "$RYU_DESTINATION"
    if RYU_COPY; then
      success
    else
      fail
    fi

  else
    echo "not a valid command"
    sleep 2
    RYU_HELP
  fi
}

GET_METHOD "$RYU_COMMAND"
