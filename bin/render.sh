#!/usr/bin/env bash
set -Eeuo pipefail

list=""

for i in $(ls tech | sort -r); do
    list+="[$i](./tech/$i)\n";
done

echo -e "\n[//]: # (RENDERED BASED ON README-template.md)" > README.md

sed "s:%tech-posts-list%:$list:g" README-template.md >> README.md

cat README.md
