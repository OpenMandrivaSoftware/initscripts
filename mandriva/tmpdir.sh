# $Id$
# Set TMPDIR to ~/tmp and create it if directory not exist.

if [ -f /etc/sysconfig/shell ];then
    . /etc/sysconfig/shell
fi

if [[ "$SECURE_TMP" = "yes" ]];then
    if [ -d ${HOME}/tmp -a -w ${HOME}/tmp ];then
        export TMPDIR=${HOME}/tmp
        export TMP=${HOME}/tmp
    elif mkdir -p ${HOME}/tmp >/dev/null 2>&1;then
        chmod 700 ${HOME}/tmp
        export TMPDIR=${HOME}/tmp
        export TMP=${HOME}/tmp
    else
        export TMPDIR=/tmp
        export TMP=/tmp
    fi
else
    export TMPDIR=/tmp
    export TMP=/tmp
fi
