#!/usr/bin/env bash

function get_extension {
  echo $(stat -c %n "$1" | rev | cut -d. -f1 | rev)
}


for file in ./*
do
  if [ -f "$file" ] ; then
#    echo "$file"": has size "$(stat -c %s "$file")" bytes"
    header=$(hexdump -n 8 -e '"\\\x" 1/1 "%02x"' -v "$file")
    footer=$(hexdump -n 8 -e '"\\\x" 1/1 "%02x"' -v "$file"\
                      -s $(($(stat -c %s "$file")-8)) )
    echo $(get_extension "$file")" yes ""$header"":""$footer"
fi
done
