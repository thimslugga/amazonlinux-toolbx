#!/bin/bash
shopt -s nullglob

CODE=0
echo "Running initial setup scripts"
for f in /etc/initial-setup.d/*.sh; do
  echo ": $f"
  "$f"
  if [ $? -ne 0 ]; then
    CODE=$?
  fi
done

for f in /etc/initial-setup.user.d/*.sh; do
  echo ": $f"
  "$f"
  if [ $? -ne 0 ]; then
    CODE=$?
  fi
done

touch /etc/initial-setup.done
exit $CODE
