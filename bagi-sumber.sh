#!/bin/bash

# Ciptakan direktori hasil kalau belum ada.
if [ ! -d usfm-hasil ]; then
  mkdir usfm-hasil
fi

# Variabel-variabel dasar.
source_usfm_directory_path="usfm-sumber/"
source_usfm_names=()
source_usfm_indexes=()
parent_directory_path="usfm-hasil/"
file_name="/100000001"
newline=$'\n'


# Ambil semua nama dan index file asli.
source_usfm_name_index=0
for FILE_NAME in $(ls ${source_usfm_directory_path} | grep -E '*.usfm'); do
  source_usfm_names+=([$source_usfm_name_index]=$FILE_NAME)

  correct_index=$(echo $FILE_NAME | grep -Po '^[0-9]{2,}')

  # Kalau index file dimulai dengan angka 0,
  if [[ $correct_index =~ ^0[0-9] ]]; then
    # hapus angka 0 tersebut.
    correct_index=$(echo $correct_index | cut -c 2)
  fi

  # Kurangi indeks dengan 2, karena kitab Kejadian memiliki indeks
  # nomor 1 dalam sistem indeksasi database filesystem Bibledit.
  correct_index=$(expr $correct_index - 2)
  source_usfm_indexes+=([$source_usfm_name_index]=$correct_index)
  ((source_usfm_name_index++))
done


# Hapus semua file yang sudah ada kalau file pertama dengan alamat di
# bawah sudah ada.
path_to_first_file="$parent_directory_path""1/0$file_name"
if [ -f "$path_to_first_file" ]; then
  rm -r "$parent_directory_path"
fi


# Ciptakan pohon direktori untuk tiap USFM sumber.
bible_book_directory_index=0
for SOURCE_USFM_NAME in ${source_usfm_names[@]}; do

  # Ciptakan nomor direktori yang benar, yang sesuai dengan sistem
  # indeksasi database filesystem Bibledit.
  current_bible_book_index=${source_usfm_indexes[$bible_book_directory_index]}
  current_book_directory_path="$parent_directory_path/$current_bible_book_index/"

  # Total jumlah pasal dan baris USFM yang sedang dibuka.
  total_chapter_count=$(grep -Ec "^[\]c" $source_usfm_directory_path$SOURCE_USFM_NAME)
  total_line_count=$(grep -c "" $source_usfm_directory_path$SOURCE_USFM_NAME)

  # Ciptakan direktori-direktori pasal dan file dengan konten pasal.
  chapter_directory_creation_index=0
  while [ $total_chapter_count -gt $chapter_directory_creation_index ]; do
    mkdir -p "$current_book_directory_path$chapter_directory_creation_index"
    touch "$current_book_directory_path$chapter_directory_creation_index$file_name"
    ((chapter_directory_creation_index++))
  done

  # Ciptakan direktori dan file terakhir yang diperlukan.
  if [ $total_chapter_count -eq $chapter_directory_creation_index ]; then
    mkdir -p "$current_book_directory_path$chapter_directory_creation_index"
    touch "$current_book_directory_path$chapter_directory_creation_index$file_name"
  fi

  # Selama masih ada baris baru,
  line_contents=""
  current_line_index=0
  chapter_directory_index=0
  while IFS= read -r line; do
    ((current_line_index++))

    # kalau terdapat "\c 01" (contoh),
    if [[ "$line" =~ ^\\c\s* ]]; then
      temp=$(expr $chapter_directory_index + 1)
      # masukkan baris itu ke file dalam file dengan index selanjutnya,
      echo ${line} >> "$current_book_directory_path$temp$file_name"
      # masukkan baris-baris yang sebelumnya dalam file dengan
      # index sekarang,
      echo "$line_contents" >> "$current_book_directory_path$chapter_directory_index$file_name"
      # tambahkan index dan bersihkan variabel pengandung isi USFM.
      ((chapter_directory_index++))
      line_contents=""
    # Kalau tidak terdapat "\c 01" (contoh),
    else
      # kalau variabel pengandung isi USFM kosong,
      # masukkan baris ke dalamnya tanpa baris baru,
      if [ -z "$line_contents" ]; then
        line_contents=${line}
      # kalau tidak,
      # masukkan dengan baris baru.
      else
        line_contents=${line_contents}$'\n'${line}
      fi

      # Kalau index file terakhir yang tertulis ditambah 1 sama dengan
      # index penciptaan file,
      if [ chapter_directory_index == chapter_directory_creation_index ]; then
        # dan kalau variabel pengandung isi USFM kosong,
        # masukkan baris yang sedang dibaca tanpa baris baru,
        if [ -z "$line_contents" ]; then
          line_contents=${line}
        # tetapi kalau tidak,
        # masukkan dengan baris baru.
        else
          line_contents=${line_contents}$'\n'${line}
        fi
      fi

      # Kalau jumlah baris dalam file target sama dengan index baris
      # file, alias baris yang terbaca adalah baris terakhir,
      if [ $total_line_count == $current_line_index ]; then
        # simpan variabel pengandung isi USFM ke dalam file terakhir.
        echo "$line_contents" >> "$current_book_directory_path$chapter_directory_index$file_name"
      fi
    fi

  done < $source_usfm_directory_path$SOURCE_USFM_NAME

  ((bible_book_directory_index++))

done
