#!/bin/bash
centers=(cards_2021)
for c in $centers; do
  for f in $(find $c -type f); do
    if [[ "$f" = *\.png ]]; then
      echo "${f}"
      convert -density 150 $f -quality 50 "${f%%.*}".jpg
    fi
  done
done
