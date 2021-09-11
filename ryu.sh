#!/bin/bash
# MIT LiCENSE
# Author:
# Stefan Lachmann, 2lach on Github

# Basic:
# ryu up|upload
# ryu down|download
#
# ryu flags --fast/slow --delete

# Details:
# ryu upload <arg1 = path to folder/file(s) to upload, defaults to . (local)> <arg2 = upload path (remote)>
# ryu download <arg1 = where it should be downloaded to, defaults to . (local)> <arg2 = item to download (remote)>

# Flags:
# --fast = uses many threads during task, expensive on memory, cpu and other resourses
# --slow = uses as few/little processing power as possible
# --delete will delete the file/folder that was uploaded downloaded when Ryu is completed
# without a --fast/--slow flag Ryu goes default which is no special tricks or power-ups

# Examples
# Upload file from your machine (local) to host (Remote)
# $ ryu upload uploaded_file.txt remote_host:/Users/Ryu/Files

# Download file from remote to local, multithreaded download
# $ ryu download /Users/Ryu/Downloads remote_host:/Users/Ryu/Files/download_file.txt --fast

# About:
# Ryu
# Because rsync is such an awesome tool I couldn't do i better
# But sometimes all thouse rsync commands are really hard to remember

# ----------------------------------------------------------------------------------------------------- #
#########################################################################################################

#########
# HELPERS ----- START
#########
function _exists() {
  if (hash "$@" 2>/dev/null); then
    return 0
  else
    return 1
  fi
}

function _exists_path() {
  if [ -d "$1" ]; then
    echo 'LOCAL_PATH Exists'
    realpath --canonicalize-existing "$1"
    LOCAL_PATH="$1"
  else
    echo 'NO LOCAL_PATH'
    LOCAL_PATH="$(realpath .)"
  fi
}

# verify that Ryu's dependencies exists
# _exists rsync
# _exists realpath

if ! _exists rsync; then
  echo "Ryu need rsync to work"
  echo "you can get it from here:"
  echo "https://rsync.samba.org/"
else
  echo 'Haduken!'
fi

if ! _exists realpath; then
  echo "Ryu uses realpath to verify files and folders exists"
fi

# verify if Ryu's paths exists
# if LOCAL_PATH exists save it to variable else save users current location realpath/$PWD as LOCAL_PATH
# if REMOTE_PATH exists save it to variable as REMOTE_PATH

# _exists_path "$1"
# _exists_path "$2"

# * Note/Idea - when dependencies are confirmed as installed Ryu should make a note > light/fast test.
#########
# Helpers ----- END
#########

# SETUP OPTIONS/VARIABLES
GET_RSYNC=$(which rsync)
RYU=$GET_RSYNC
LOCAL_PATH
REMOTE_PATH="$1"

function run_ryu() {

  # info and logging:
  # -v              increase verbosity
  # --info=FLAGS    fine-grained informational verbosity
  # --debug=FLAGS   fine-grained debug verbosity
  # --log-file=FILE log what we're doing to the specified FILE

  # USE:
  # --recursive, -r          recurse into directories

  $RYU

}

function ryu_builder() {
  # this is where the final ryu function gets compiled and then send to run_ryu()

  echo 'Finally when Ryu is completed'
  # Finalize with
  # if [ Ryu == "successful"]
  #   play Haduken sound
  # else
  #   play 'tetris sound when lost level'

}

function upload() {
  echo "Rsync from local($1) to remote($2)"
}

function download() {
  echo "Rsync from remote($2) to local($1)"
}

function fast() {
  # run rsync multithreaded/parallell exection

  # -z, –compress                          compress file data during the transfer

  # from https://wiki.ncsa.illinois.edu/display/~wglick/2013/11/01/Parallel+Rsync

  # export SRCDIR="/folder/path"
  # export DESTDIR="/folder2/path"
  # export THREADS="8"

  # # RSYNC DIRECTORY STRUCTURE
  # rsync -zr -f"+ */" -f"- *" $SRCDIR/ $DESTDIR/ \

  # # FOLLOWING MAYBE FASTER BUT NOT AS FLEXIBLE
  # # cd $SRCDIR; find . -type d -print0 | cpio -0pdm $DESTDIR/

  # # FIND ALL FILES AND PASS THEM TO MULTIPLE RSYNC PROCESSES
  cd $SRCDIR && find . ! -type d -print0 | xargs -0 -n1 -P$THREADS -I% rsync -az % $DESTDIR/%

  # MULTIPLE RSYNC PROCESSES OVER SSH
  rsync -zr -f"+ */" -f"- *" -e 'ssh -c arcfour' $SRCDIR/ remotehost:/$DESTDIR/ &&
    cd $SRCDIR && find . ! -type d -print0 | xargs -0 -n1 -P$THREADS -I% rsync -az -e 'ssh -c arcfour' % remotehost:/$DESTDIR/%

}

function slow() {
  #   ionice -c2        to limit the IO priority
  #  --bwlimit=RATE     limit socket I/O bandwidth
  rsync --bwlimit=RATE
}

function delete() {
  #  Remove files from source after synchronization (–remove-source-files)
  rsync --remove-source-files -zvh /home/pkumar/techi.tgz
}

function flags() {
  # read/regex input arguments
  # decide if flags where present
  # if flags where present call flags function (add to ryu_builder)

  #NOTE: "$@"" should be save in a OPTION/VARIABLE
  RYU_ARGUMENTS=($@)
  FLAG_FAST="--fast"
  FLAG_SLOW="--slow"
  FLAG_DELETE="--delete"
  ALLOWED_FLAGS=($FLAG_FAST $FLAG_SLOW $FLAG_DELETE)

  # REGEX CHECKER
  # for value in "${ALLOWED_FLAGS[@]}"
  # do
  #  [[ "$flag" == *"$FLAG"* ]]
  #   echo $flag Is present"
  # fi
  # done

}

function paths() {
  echo "adds $LOCAL_PATH and $REMOTE_PATH to Ryu-builder"

  # DOWNLOAD
  # $ echo Downloading {$file(s)/dir} from: $REMOTE
  # $ echo to: $LOCAL_PATH

  # UPLOAD
  # $ echo Uploading/Copying {file(s)/dir} from: from: $LOCAL_PATH

  # NOTE: define if Ryu action is Upload or copy if there is a remotehost present in $REMOTE_PATH
  # $ echo to: $REMOTE_PATH
}

# Notes
#-------------------------------------------------------------------
# rsync man page
# https://rsync.samba.org/ftp/rsync/rsync.html

# rsync examples
# https://rsync.samba.org/examples.html

# rsync features
# https://rsync.samba.org/features.html

# rsync facts
# https://rsync.samba.org/FAQ.html

# rsync man page
# https://download.samba.org/pub/rsync/rsync.1

# some tutorials on rsync:
# https://everythinglinux.org/rsync/

# realpath docs/usage
# https://www.gnu.org/software/coreutils/manual/html_node/Realpath-usage-examples.html#Realpath-usage-examples
#
#
#
#
