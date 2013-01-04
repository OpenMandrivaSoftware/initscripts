#!/bin/sh
#
# Rewritten in shell script:
# Copyright 2013 Per Øyvind Karlsen <peroyvind@mandriva.org>
#
# Original perl script:
# Guillaume Cottenceau (gc@mandriva.com)
#
# Copyright 2002 Mandriva
#
# This software may be freely redistributed under the terms of the GNU
# public license.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#

verbose=0
while [ -n "$1" ]; do
    if [ "$1" == "-h" ]; then
	echo "usage: partmon [-v]"
	exit -1
    elif [ "$1" == "-v" ]; then
	verbose=1
    fi
    shift
done

free_space() {
    local mntpoint="$1"
    local all="$(stat --file-system "$1" --format=%S:%b:%a)"
    local blocksize=${all%%:*}
    local all=${all#*:}
    local size=${all%:*}
    local all=${all#*:}
    local avail=${all%:*}
    echo $(($avail * ($blocksize / 1024)))
}

ok=1
while read -r line
do    
    mountpoint="$(echo $line | sed -e 's#\s*\S*\d*$##')"
    partlimit="$(echo $line | grep -o '\w*\d*$')"
    case "$mountpoint" in
	/*)
	    if mountpoint -q "$mountpoint"; then
		free=$(free_space "$mountpoint")
		if [ $verbose -ne 0 ]; then
		    echo "Free space of <$mountpoint> is <$free>";
		fi
		if [ $free -lt $partlimit ]; then
		    echo "Warning, free space for <$mountpoint> is only <$free> (which is inferior to <$partlimit>)"
		    ok=0
		fi
	    fi
	    ;;
	*) continue
	    ;;
    esac
done < /etc/sysconfig/partmon

if [ $ok -eq 0 ]; then
    exit -1
else
    exit 0
fi

#-------------------------------------------------
#- $Log$
#- Revision 1.4  2013/01/04 04:03:00  proyvind
#- rewrite from perl to schell script
#-
#- Revision 1.3  2006/05/11 12:45:38  tvignaud
#- more s/Mandrakesoft/mandriva/
#-
#- Revision 1.2  2002/01/15 13:45:24  chmouel
#- Fix warnings.
#-
#- Revision 1.1  2002/01/15 13:44:15  chmouel
#- Add partition monitor from GC
#-
