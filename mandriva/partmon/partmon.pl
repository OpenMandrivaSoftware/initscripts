#!/usr/bin/perl
#
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
#use strict;
use MDK::Common;

my ($verbose);

sub free_space {
    my ($mntpoint) = @_;
    my ($blocksize, $size, $avail);
    my $buf = ' ' x 20000;
    syscall_('statfs', $mntpoint, $buf) or return;
    (undef, $blocksize, $size, undef, $avail, undef) = unpack "L!6", $buf;
    return $avail * ($blocksize / 1024);
}

my %partlimits = map { if_(/^(.*\S)(?:\s+?)(\d+)$/, $1 => $2 ) } cat_('/etc/sysconfig/partmon');


my $params = join '', @ARGV;

$params =~ /-h/ and die "usage: partmon [-v]\n";
$params =~ /-v/ and $verbose = 1;


my $ok = 1;
foreach (cat_('/etc/fstab')) {
    /^\s*#/ and next;
    my (undef, $mountpoint, undef, undef, undef, undef) = split or next;  #- I want at least 6 fields to consider it a valid entry
    member($mountpoint, keys %partlimits) or next;
    my $free = free_space($mountpoint);
    $verbose and print "Free space of <$mountpoint> is <$free>\n";
    if ($free < $partlimits{$mountpoint}) {
	print "Warning, free space for <$mountpoint> is only <", free_space($mountpoint), "> (which is inferior to <$partlimits{$mountpoint}>\n";
	$ok = 0;
    }
}

$ok or exit -1;


#-------------------------------------------------
#- $Log$
#- Revision 1.3  2006/05/11 12:45:38  tvignaud
#- more s/Mandrakesoft/mandriva/
#-
#- Revision 1.2  2002/01/15 13:45:24  chmouel
#- Fix warnings.
#-
#- Revision 1.1  2002/01/15 13:44:15  chmouel
#- Add partition monitor from GC
#-
