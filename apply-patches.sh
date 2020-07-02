#!/bin/bash
#
# Patch script originally written by phhusson
# Modified by diepquynh
#

set -e

patches="$(readlink -f -- $1)"

for project in $(cd $patches/patches; echo *);do
	p="$(tr _ / <<<$project |sed -e 's;platform/;;g')"
	[ "$p" == build ] && p=build/make
	repo sync -l --force-sync $p
	pushd $p
	git clean -fdx; git reset --hard
	for patch in $patches/patches/$project/*.patch;do
		#Check if patch is already applied
		if patch -p1 --dry-run -R < $patch > /dev/null;then
			continue
		fi

		git am $patch
		#patch -f -p1 < $patch
	done
	popd
done

