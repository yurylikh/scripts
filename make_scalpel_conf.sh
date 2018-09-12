#!/bin/bash

function print_extension {
  echo $(stat -c %n "$1" | rev | cut -d. -f1 | rev)
}

function compose_line_for {
  file="$1"
  header=$(hexdump -n 8 -e '"\\\x" 1/1 "%02x"' -v "$file")
  footer=$(hexdump -n 8 -e '"\\\x" 1/1 "%02x"' -v "$file"\
                        -s $(($(stat -c %s "$file")-8)) )
#  echo "$file"": has size "$(stat -c %s "$file")" bytes"
  echo $(print_extension "$file")" yes ""$header"":""$footer"
}

function process_files_in_dir {	
  for file in "$1"/* ; do
    if [ -f "$file" ] && [ -s "$file" ] ; then
      echo "$file"
      echo $(compose_line_for "$file")
    elif [ -d "$file" ] ; then
      cd "$file"
      echo "$(pwd)"
      $(process_files_in_dir "$(pwd)")
    fi
  done
}

if [ -n "$#" ] && [ -d "$1" ] ; then 
  $(process_files_in_dir "$1")
fi
