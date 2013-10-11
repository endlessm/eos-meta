#!/bin/bash -e

GIT=git

if [[ $# -le 0 ]]; then
  echo "Usage $0 <package_name>..." 2>&1
  exit 1
fi

# Removed until we can have comments in the file
#  echo "Usage $0 [ core, endless, extra ] <package_name>..." 2>&1
#  exit 1
#fi

#if [[ ! $1 =~ core|endless|extra ]]; then
#  echo "Section must be one of core, endless, or extra" 2>&1
#  exit 1
#fi

#echo "Using section: $1"
#SECTION=$1
#shift

PACKAGES=$@
echo "Adding packages $PACKAGES"

for arch_file in $(ls core-* | grep -v recommends); do
  echo "Processing arch: $arch_file"
  for package_name in $PACKAGES; do
    echo "- Adding $package_name"
    echo "$package_name" >> $arch_file
  done

  echo "Confirm the changes!"
  $GIT add -p -- $arch_file
done

echo "Commiting changes to Git"
$GIT commit -m "Added $PACKAGES as dependencies"

echo "Updating changelog version"
./bump_version.sh "Autoadd - Added $PACKAGES to dependencies"

echo "Saving changelog to Git"
$GIT add debian/changelog
$GIT commit -m "Updated the changelog"

echo "Done. Make sure that the git patch is correct before pushing"
