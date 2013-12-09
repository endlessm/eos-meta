if [[ $# -le 0 ]]; then
  echo "Usage $0 <package_name>..." 2>&1
  exit 1
fi

# Get name
if [ "" = "${USER_NAME}" ]; then
  echo "Reading git config user.name"
  user_name=`git config --get user.name`
else
  user_name="${USER_NAME}"
fi

if [ "" = "${user_name}" ]; then
  echo "User name not set. Aborting!"
  exit 1
fi
echo "Using user name ${user_name}"
export DEBFULLNAME="${user_name}"

# Get email
if [ "" = "${USER_EMAIL}" ]; then
  echo "Reading git config user.email"
  user_email=`git config --get user.email`
else
  user_email="${USER_EMAIL}"
fi

if [ "" = "${user_email}" ]; then
  echo "User email not set. Aborting!"
  exit 1
fi
echo "Using user email ${user_email}"
export DEBEMAIL="${user_email}"

# Bump version
OLD_VERSION=$(head -1 debian/changelog | awk '{print $2}' | sed -e 's:(\(.*[0-9\.]*\)):\1:g')
echo "Old Version: $OLD_VERSION"

NEW_VERSION=$(bc <<< "new_ver = $OLD_VERSION + 0.01; if (new_ver < 1) print 0; new_ver")
echo "New Version: $NEW_VERSION"

COMMENT="Autoadd - Added ${@} to dependencies"

dch --force-distribution -m "${COMMENT}" -D eos -v $NEW_VERSION

debian_branch=$(git branch | grep \* | awk '{print $2}')

echo "Creating tags on $debian_branch"
git add debian/changelog
git commit -m "Added ${@} to dependencies"
git tag -f -a "Version_${NEW_VERSION}_debian" -m "Autoadd - Added ${@} to dependencies"

echo "Done. Don't forget to push, and push tags with git push origin --tags"
