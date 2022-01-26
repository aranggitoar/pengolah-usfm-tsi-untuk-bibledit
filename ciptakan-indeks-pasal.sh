#!/bin/bash

source="usfm-hasil/AlkitabKita/"

for folder in $(ls $source); do
  if [ -d $source$folder ]; then
    index_file="$source$folder/index"
    if [ -f $index_file ]; then
      rm $index_file
    fi
    chapter_count=$(ls $source$folder/ | wc -l)
    touch $index_file
    echo $chapter_count >> $index_file
  fi
done
