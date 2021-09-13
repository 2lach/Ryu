#!/bin/bash
function _exists() {
  if (hash "$@" 2>/dev/null); then
    return 0
  else
    return 1
  fi
}

if ! _exists rsync; then
  echo "Ryu need rsync to work"
  if _exists brew; then
    echo "since you got homebrew installed"
    echo "you can get it with:"
    echo "# brew install rsync"
  else
    echo "you can get it from here:"
    echo "https://rsync.samba.org/"
  fi
else
  echo 'rsync exists'
  echo 'Haduken!'
fi
