eos-shell-apps
==============

Applications for EndlessOS (for use with new eos-shell)

To build package and install applications (on Ubuntu 13.04 w/ GNOME3 PPA):
./build.sh
sudo add-apt-repository "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"
sudo apt-get update
sudo dpkg -i endlessos-base-apps_1.0_all.deb
sudo apt-get install -f
