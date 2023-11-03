#!/bin/bash

lcovFile=$1
lines=$(cat $lcovFile)
coverage=(0 0)

for line in $lines; do
  if [[ $line == DA* ]]; then
    totalLines=$((coverage[1] + 1))
    testedLines=${coverage[0]}
    if [[ $line != *",0" ]]; then
      testedLines=$((testedLines + 1))
    fi
    coverage=($testedLines $totalLines)
  fi
done

testedLines=${coverage[0]}
totalLines=${coverage[1]}
percentage=$((testedLines * 100 / totalLines))
if [[ $percentage -lt 95 ]]; then
  echo "Coverage is below 95%"
  exit 1
fi
exit 0