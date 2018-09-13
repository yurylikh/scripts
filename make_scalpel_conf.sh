#!/usr/bin/env bash

function process_file {
  file="$1"
  bits=8
  format='"\\\x" 1/1 "%02x"'
  extension=${file##*.}
#  extension=$(stat -c %n "$file"|rev|cut -d. -f1|rev)
  header=$(hexdump -n $bits -e "$format" -v "$file")
  footer=$(hexdump -n $bits -e "$format" -v "$file"\
                   -s $(($(stat -c %s "$file")-$bits)) )
  echo $extension "y" $header":"$footer
}

function process_dir {
  for file in "$1"/* ; do
    if [ -d "$file" ] ; then
      process_dir "$file"
    elif [ -f "$file" ] && [ -s "$file" ] ; then
      process_file "$file"
    fi
  done
}

function main {
  if [ -d "$1" ] ; then
    process_dir "$1"
  fi
}


if [ -z "$#" ] ; then 
  echo "Incorrect usage."
  echo "Usage: <script> <dir>"
else
  main "$1"
fi
