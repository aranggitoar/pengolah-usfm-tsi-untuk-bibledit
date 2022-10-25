#!/bin/bash

rm -rf usfm-sumber
rm -rf usfm-hasil
echo "------------------------------"
echo "Mengunduh file-file USFM TSI yang sudah siap dibaca ..."
echo "------------------------------"
./ambil-sumber.sh
echo "------------------------------"
echo "Selesai mengunduh."
echo "------------------------------"
echo "Merapikan nama file USFM TSI ..."
echo "------------------------------"
./sesuaikan-nama-file.sh
echo "------------------------------"
echo "Selesai merapikan."
echo "------------------------------"
echo "Membagi isi dari file-file USFM TSI sesuai keperluan ..."
echo "------------------------------"
./bagi-sumber.sh
echo "------------------------------"
echo "Selesai membagi."
echo "------------------------------"
echo "Menciptakan file-file indeks untuk tiap direktori pasal ..."
echo "------------------------------"
./ciptakan-indeks-pasal.sh
echo "------------------------------"
echo "Selesai menciptakan."
echo "------------------------------"
echo "Semua file USFM siap digunakan dalam direktori 'AlkitabKita' dalam 'usfm-hasil'."
echo "------------------------------"
