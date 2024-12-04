#!/bin/bash
shopt -s nullglob

CODE=0
echo "Running start scripts"
for f in /etc/start-scripts.d/*.sh; do
  echo ": $f"
  "$f"
  if [ $? -ne 0 ]; then
    CODE=$?
  fi
done

for f in /etc/start-scripts.user.d/*.sh; do
  echo ": $f"
  "$f"
  if [ $? -ne 0 ]; then
    CODE=$?
  fi
done

exit $CODE
