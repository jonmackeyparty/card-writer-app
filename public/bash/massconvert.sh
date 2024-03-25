#!/bin/bash
centers=(cards_2021)
for c in $centers; do
  for f in $(find $c -type f); do
    if [[ "$f" != *\.pdf ]]; then
      echo "${f%%.*}"
      convert $f -negate -lat 20x20+10% -negate -type bilevel -define connected-components:area-threshold=10 -define connected-components:mean-color=true -connected-components 4 -fuzz 15% -trim +repage -quality 50 "${f%%.*}"_converted.png
    fi
  done
done
