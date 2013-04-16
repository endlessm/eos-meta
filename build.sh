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

	pushd ../eos-build &> /dev/null
      INSTALL_DIR=$(pwd)
		export GNUPGHOME=${INSTALL_DIR}/gnupg
	popd &> /dev/null

  # Build package
  debuild -k4EB55A92 -b
  
  # Move package to this directory and clean up
   mv ../*apps*.deb .
   mv ../*apps*.changes .
   rm -f ../*.build
popd
