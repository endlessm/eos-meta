eos-shell-apps
==============

Applications for EndlessOS (for use with new eos-shell)

To build package and install applications (on Ubuntu 13.04 w/ GNOME3 PPA):
git clone https://github.com/endlessm/eos-build
git clone https://github.com/endlessm/eos-shell-apps
cd eos-shell-apps
./build.sh
sudo add-apt-repository -y "deb http://archive.canonical.com/ubuntu $(lsb_release -sc) partner"
sudo add-apt-repository -y "deb http://ppa.launchpad.net/sgringwe/beatbox/ubuntu quantal main"
sudo apt-get update
sudo dpkg -i endlessos-base-apps_1.0_all.deb
sudo apt-get install -f

Note that a "raring" version of beatbox is not currently available in the PPA,
so for now we point to the older "quantal" version.
Once the "raring" version is available, the addition of the sgringwe
repository can be simplified with the following:
sudo add-apt-repository -y ppa:sgringwe/beatbox
