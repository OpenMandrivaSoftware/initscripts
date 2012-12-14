#!/bin/sh

# http://svnbook.red-bean.com/en/1.0/ch07s04.html (Vendor branches)
# http://subversion.tigris.org/faq.html#merge-using-tags

set -e

SVNROOT=svn+ssh://svn.mandriva.com/svn/soft
RH_BRANCH=RedHat
RH_SRC_RPM=$1
LAST_MERGE_TAG=rh_last_merge

if [ -z $RH_SRC_RPM ]; then
    echo "syntax: $0 <redhat src.rpm>"
    exit
fi

NAME=`rpm -qp --qf '%{name}' $1`
VERSION=`rpm -qp --qf '%{version}' $1`
VC_VERSION=rh${VERSION/./_}

RH_DIR=$NAME-$VERSION
RH_TAR=$RH_DIR.tar.bz2

rpm2cpio $RH_SRC_RPM | cpio -ivd $RH_TAR
tar xjf $RH_TAR
# remove po files, we do not care and do not want to waste space on SVN
rm -rf $RH_DIR/po/*.po{,t}

mv $RH_TAR `rpm --eval %_topdir`/SOURCES

TOP_PATH=$SVNROOT/$NAME
BRANCH_PATH=$TOP_PATH/branches/$RH_BRANCH
LAST_MERGE_PATH=$TOP_PATH/tags/$LAST_MERGE_TAG

svn delete -m "remove old last merge tag" $LAST_MERGE_PATH
svn copy -m "tagging rh last merge (prep for $VC_VERSION merge)" $BRANCH_PATH $LAST_MERGE_PATH
svn_load_dirs.pl -t tags/$VC_VERSION $TOP_PATH branches/$RH_BRANCH $RH_DIR

rm -rf $RH_DIR

echo "Imported rh $VERSION sources"
echo "Please run:"
# needed to avoid mismerge because ChangeLog is a symlink here
echo \* svn merge $LAST_MERGE_PATH $BRANCH_PATH
echo \* svn update
