#!/bin/bash -e

if [[ $# -lt 2 ]]; then
  echo "Usage $0 [ core, endless, extra ] <package_name>..." 2>&1
  exit 1
fi

if [[ ! $1 =~ core|endless|extra ]]; then
  echo "Section must be one of core, endless, or extra" 2>&1
  exit 1
fi

echo "Using section: $1"
SECTION=$1
shift

echo "Adding packages $@"

for arch_file in core-*; do
  echo "Processing arch: $arch_file"
  for package_name in $@; do
    echo "- Adding $package_name"
    echo "$package_name" >> $arch_file
  done

  echo "Confirm the changes!"
  git add -p -- $arch_file
done

git commit -m "Added $@ as dependencies"

