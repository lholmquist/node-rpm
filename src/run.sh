#!/bin/sh

version=$(rpm -q --specfile --qf='%{version}\n' nodejs.spec | head -n1)
echo "Building with version $version"

old_build_dir=/root/rpmbuild_usr_src_debug/BUILD/nodejs
new_build_dir=$(dirname $old_build_dir)/node-v${version}
echo "old_build_dir:" ${old_build_dir}
echo "new_build_dir:" ${new_build_dir}

ln -s $old_build_dir $new_build_dir

pushd ${new_build_dir}
git fetch origin refs/tags/v${version}:refs/tags/v${version}
## remove addons before checking out
rm -rf test/addons
rm -rf test/addons-napi
git checkout -fb ${version} v${version}
git checkout test/
tar -zcf node-v${version}.tar.gz --transform "s/^node/node-v${version}/" $new_build_dir
mv node-v${version}.tar.gz /root/rpmbuild_usr_src_debug/SOURCES
popd

## Build the rpm
pushd $(dirname $new_build_dir)
rpmbuild -ba --noclean --define='basebuild 0' /usr/src/node-rpm/nodejs.spec
popd
