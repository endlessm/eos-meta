#!/bin/bash -e

# Install dependencies
DEPENDENCIES="devscripts debhelper"
set +e 
  dpkg -s $DEPENDENCIES &> /dev/null
  has_dependencies=$?
set -e

if [[ $has_dependencies -ne 0 ]]; then
  sudo apt-get install -y $DEPENDENCIES
fi

pushd `dirname $0`
  
  # Clean up old artifacts
   set +e
		rm -rf *.deb
		rm -rf *.changes
   set -e

  # Build package
  debuild -uc -us -b
  
  # Move package to this directory and clean up
   mv ../*apps*.deb .
   mv ../*apps*.changes .
   rm -f ../*.build
popd
