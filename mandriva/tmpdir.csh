# $Id$
# Set TMPDIR and TMP

if (-f /etc/sysconfig/shell) then
    eval `cat /etc/sysconfig/shell | grep -v ^# | sed -re 's/^([^=]+=)/set \1/'`
endif

if ($?SECURE_TMP) then
    if ($SECURE_TMP == "yes") then
        if ( -d ${HOME}/tmp && -w ${HOME}/tmp ) then
            setenv TMPDIR ${HOME}/tmp
            setenv TMP ${HOME}/tmp
            exit
        endif

        if ( { mkdir -p ${HOME}/tmp >&! /dev/null } ) then 
            setenv TMPDIR ${HOME}/tmp
            setenv TMP ${HOME}/tmp
            exit
        endif
    endif
endif

setenv TMPDIR /tmp
setenv TMP /tmp
