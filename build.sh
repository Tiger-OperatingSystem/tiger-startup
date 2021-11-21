#!/bin/bash

[ ! "${EUID}" = "0" ] && {
  echo "Execute esse script como root:"
  echo
  echo "  sudo ${0}"
  echo
  exit 1
}

HERE="$(dirname "$(readlink -f "${0}")")"

working_dir=$(mktemp -d)

mkdir -p "${working_dir}/usr/bin/"
mkdir -p "${working_dir}/usr/share/xsessions/"
mkdir -p "${working_dir}/usr/usr/lib/systemd/system/"
mkdir -p "${working_dir}/DEBIAN/"


cp -v "${HERE}/tiger-live" "${working_dir}/usr/bin/"
cp -v "${HERE}/tiger-session" "${working_dir}/usr/bin/"
cp -v "${HERE}/tiger-session.desktop" "${working_dir}/usr/share/xsessions/"
cp -v "${HERE}/tiger-live.service" "${working_dir}/usr/usr/lib/systemd/system/"
cp -v "${HERE}/postinst" "${working_dir}/DEBIAN/"

chmod -Rv a+x "${working_dir}/usr/bin/"
chmod -v a+x "${working_dir}/DEBIAN/postinst"

(
 echo "Package: tiger-startup"
 echo "Priority: required"
 echo "Version: 1.0"
 echo "Architecture: all"
 echo "Maintainer: Natanael Barbosa Santos"
 echo "Depends: "
 echo "Description: $(cat ${HERE}/README.md  | sed -n '1p')"
 echo
) > "${working_dir}/DEBIAN/control"

dpkg -b ${working_dir}
rm -rfv ${working_dir}

mv "${working_dir}.deb" "${HERE}/tiger-startup.deb"

chmod 777 "${HERE}/tiger-startup.deb"
chmod -x  "${HERE}/tiger-startup.deb"
