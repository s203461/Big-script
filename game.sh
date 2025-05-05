#!/bin/bash
choose_word() {
  local file=$1
  mapfile -t words < "$file"
  target_word=${words[RANDOM % ${#words[@]}]}
  target_length=${#target_word}
}

check_guess() {
  local guess=$1
  local result=""
  for ((i=0; i<target_length; i++)); do
    local g=${guess:i:1}
    local t=${target_word:i:1}
    if [[ "$g" == "$t" ]]; then
      result+="\e[1;32m$g\e[0m"
    elif [[ "$target_word" == *"$g"* ]]; then
      result+="\e[1;33m$g\e[0m"
    else
      result+="\e[1;90m$g\e[0m"
    fi
  done
  echo -e "$result"
  [[ "$guess" == "$target_word" ]]
}

zenity_mode() {
  zenity --entry --title="Wordle" --text="Podaj słowo:"
}
zenity_wrong(){
zenity --warning --text="Niepoprawna odpowiedź"
}
