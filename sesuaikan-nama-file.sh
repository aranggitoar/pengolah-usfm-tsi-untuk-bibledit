#!/bin/bash

# Rapikan file ini, dia berfungsi tetapi kurang rapi.

array_of_falsy_names=()
array_of_correct_names=()
array_of_names_to_correct=()
path_to_files="usfm-sumber/"
path_to_sos=$path_to_files"22_Song of Solomon.usfm"
path_to_correct_sos=$path_to_files"22_SongofSolomon.usfm"
falsy_array_index=0
correct_array_index=0
temp_index=0
correction_index=0


# Perbaikan cepat untuk Kidung Agung

if [ -f "$path_to_sos" ]; then
  echo "Dari $path_to_sos .."
  mv "$path_to_sos" "$path_to_correct_sos"
  echo ".. menjadi $path_to_correct_sos"
fi


for NAME in $(ls ${path_to_files} | grep ' '); do

  array_of_falsy_names+=([$falsy_array_index]=$NAME)
  # echo $NAME
  ((falsy_array_index++))

done


for NAME in ${array_of_falsy_names[@]}; do

  if [[ ${array_of_falsy_names[$temp_index]} =~ ^[0-9] ]]; then
    array_of_correct_names+=([$correct_array_index]=$NAME)
    array_of_names_to_correct+=([$correct_array_index]=$NAME)
  else
    last_correct_name=${array_of_correct_names[$correct_array_index]}
    last_name_to_correct=${array_of_names_to_correct[$correct_array_index]}
    array_of_correct_names+=([$correct_array_index]="$last_correct_name$NAME")

    echo "Dari $path_to_files$last_name_to_correct $NAME .."

    array_of_names_to_correct+=([$correct_array_index]="$last_name_to_correct $NAME")

    echo ".. menjadi $path_to_files$last_correct_name$NAME"

    ((correct_array_index++))

    mv "$path_to_files$last_name_to_correct $NAME" "$path_to_files$last_correct_name$NAME"
  fi

  ((temp_index++))

done

# Cetak semua array untuk debugging.
# echo ${array_of_falsy_names[@]}
# echo ${array_of_correct_names[@]}
# echo ${array_of_names_to_correct[@]}
