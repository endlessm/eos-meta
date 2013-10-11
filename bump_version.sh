export DEBEMAIL=sgnn7@sgnn7.org
export DEBFULLNAME="Srdjan Grubor"

OLD_VERSION=$(head -1 debian/changelog | awk '{print $2}' | sed -e 's:(\(.*[0-9\.]*\)):\1:g')
echo "Old Version: $OLD_VERSION"

NEW_VERSION=$(bc <<< "new_ver = $OLD_VERSION + 0.01; if (new_ver < 1) print 0; new_ver")
echo "New Version: $NEW_VERSION"

dch --force-distribution -m "$@" -D eos -v $NEW_VERSION
