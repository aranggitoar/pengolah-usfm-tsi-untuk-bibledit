#!/bin/bash

# Rapikan file ini, dia berfungsi tetapi kurang rapi.

array_of_falsy_names=()
array_of_correct_names=()
array_of_names_to_correct=()
path_to_files="usfm-sumber/"
falsy_array_index=0
correct_array_index=0
temp_index=0
correction_index=0


for NAME in $(ls ${path_to_files} | grep ' '); do

  array_of_falsy_names+=([$falsy_array_index]=$NAME)
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

    echo "Dari $path_to_original_files$last_name_to_correct $NAME .."

    array_of_names_to_correct+=([$correct_array_index]="$last_name_to_correct $NAME")

    echo ".. menjadi $path_to_target_files$last_correct_name$NAME"

    ((correct_array_index++))

    mv "$path_to_files$last_name_to_correct $NAME" "$path_to_files$last_correct_name$NAME"
  fi

  ((temp_index++))

done

# Cetak semua array untuk debugging.
# echo ${array_of_falsy_names[@]}
# echo ${array_of_correct_names[@]}
# echo ${array_of_names_to_correct[@]}
