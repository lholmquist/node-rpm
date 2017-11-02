#!/bin/sh

version=$(rpm -q --specfile --qf='%{version}\n' nodejs.spec | head -n1)
echo "Building version $version"

git clone https://github.com/bucharest-gold/node.git -b v${version}-rh node-v${version}
tar -zcf node-v${version}-rh.tar.gz node-v${version}
mv node-v${version}-rh.tar.gz /opt/app-root/src/rpmbuild/SOURCES/node-v${version}-rh.tar.gz

## Build the rpm
rpmbuild -ba --noclean --define='basebuild 0' /usr/src/node-rpm/nodejs.spec