#!/bin/bash
load_config() {
  if [ -f config.txt ]; then
    source config.txt
  fi
}

save_config() {
  echo "DICT_FILE=\"$DICT_FILE\"" > config.txt
  echo "MAX_ATTEMPTS=\"$MAX_ATTEMPTS\"" >> config.txt
}
