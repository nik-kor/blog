#!/usr/bin/env bash
set -Eeuo pipefail

list=""

for i in $(ls tech | sort -r); do
    date=${i:0:10}
    title=$(echo "$i" | sed "s/$date-//" | sed "s/.md//")
    list+="- [$date $title](./tech/$i)\n";
done

echo -e "\n[//]: # (RENDERED BASED ON README-template.md)" > README.md
sed "s:%tech-posts-list%:$list:g" README-template.md >> README.md

cat README.md
