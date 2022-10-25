#!/bin/bash

# Ciptakan direktori sumber kalau belum ada.
if [ ! -d usfm-sumber ]; then
  mkdir usfm-sumber
fi

# Semua kecuali yang disaring,
# adalah Alkitab yang siap pada 26 Januari 2022.
wget -r -np -nH --cut-dirs=4 -R \
  "index.html*","robots.txt*","0[0-2 | 5-6 | 8-9]*","1[3-6]*","2[0-1 | 4-9]*","3[0-3 | 5-9]*","4[0-1]*","stylesheet.css*" \
  -P usfm-sumber http://timkita.xyz:2026/exports/TSI/usfm/full/
