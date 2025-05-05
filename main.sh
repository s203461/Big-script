#!/bin/bash
#Author : Bartosz Zambrzycki
#Created On : 03.05.2025
#Last Modified By: Bartosz Zambrzycki
#Last Modified On: 04.05.2025
#Version : 1.0
#
#Description : Wordle game

source config.sh
source game.sh

DICT_FILE="mail.txt"
MAX_ATTEMPTS=6
USE_GUI=false
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
if [[ -f wordle.1 ]]; then
man ./wordle.1
fi
exit 0
fi
while getopts ":f:a:gs" opt; do
  case ${opt} in
    f )
      DICT_FILE="$OPTARG"
      ;;
    a )
      MAX_ATTEMPTS="$OPTARG"
      ;;
    g )
      USE_GUI=true
      ;;
    s )
       save_config
       echo "Konfiugracja zapisana"
       exit 0
      ;;
    \? )
      echo "Błędna opcja: -$OPTARG" >&2
      exit 1
      ;;
    : )
      echo "Brak wartości dla opcji: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

load_config

choose_word "$DICT_FILE"
echo "Zgadnij $target_length-literowe słowo w $MAX_ATTEMPTS próbach."

for ((attempt=0; attempt<MAX_ATTEMPTS; attempt++)); do
  echo "Pozostało prób: $((MAX_ATTEMPTS - attempt))"

  if $USE_GUI; then
    guess=$(zenity_mode)
  else
    read -p "Podaj słowo: " guess
  fi

  guess=$(echo "$guess" | tr '[:upper:]' '[:lower:]')

  if [ ${#guess} -ne $target_length ]; then
  if $USE_GUI; then
  zenity_wrong
  else echo "Błędna długość"
  fi
  fi
  if ! grep -q -i -w "$guess" "$DICT_FILE"; then echo "Nie ma w słowniku"; continue; fi

  check_guess "$guess" && {
    echo "Wygrana"
    exit 0
  }
done

echo "Porażka"
