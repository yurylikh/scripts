#!/usr/bin/env bash

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


for file in ./* ; do
  if [ -f "$file" ] && [ -s "$file" ] ; then
    echo $(compose_line_for "$file")
  fi
done
