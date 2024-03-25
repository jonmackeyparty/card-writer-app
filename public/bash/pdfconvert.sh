#!/bin/bash
centers=(cards_2022)
for c in $centers; do
  for f in $(find $c -type f); do
    if [[ "$f" = *\.pdf ]]; then
      echo "${f}"
      convert -density 150 $f -quality 50 "${f%%.*}".jpg
    fi
  done
done
