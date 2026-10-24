#!/bin/bash
if [ -z "$1" ]; then
  echo "Использование: $0 <URL>"
  exit 1
fi

URL="$1"
STATUS_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$URL")

if [[ "$STATUS_CODE" =~ ^2[0-9]{2}$ ]]; then
  echo "API доступен, код ответа: $STATUS_CODE"
  exit 0
else
  echo "API недоступен, код ответа: $STATUS_CODE"
  exit 1
fi
