#!/bin/bash
set -e
set -o pipefail

ERRORS=()

# find all executables and run `shellcheck`
for f in $(find . -type f -not -iwholename '*.git*' | sort -u); do
  if file "$f" | grep --quiet shell; then
    {
      shellcheck "$f" && echo "[OK]: sucessfully linted $f"
    } || {
      # add to errors
      ERRORS+=("$f")
    }
  fi
done

if [ ${#ERRORS[@]} -eq 0 ]; then
  echo "No errors, hooray"
else
  echo "These files failed shellcheck: ${ERRORS[*]}"
  exit 1
fi

test_shells() {
  fmt="%s\t%s\n"
  for shell in "$@"; do
    if test_shell $shell; then
      printf $fmt $shell PASS
    else
      printf $fmt $shell FAIL
    fi
  done
}

test_shells sh bash dash zsh ksh csh tcsh gosh
